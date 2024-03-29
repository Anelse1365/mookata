import 'dart:math';
import 'package:flutter/material.dart';
import '../TransactionItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final typeController = TextEditingController();
  final amountController = TextEditingController();
  final id = generateRandomString(8);

  String? _selectedIngredientType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 162, 28),
        title: const Text("เพิ่มข้อมูลสินค้า"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "ชื่อสินค้า",
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (str) {
                  if (str!.isEmpty) {
                    return "กรุณาใส่ชื่อสินค้า";
                  }
                  return null;
                },
                controller: itemNameController,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'ประเภทสินค้า',
                  border: OutlineInputBorder(),
                ),
                value: _selectedIngredientType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIngredientType = newValue;
                    typeController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกประเภทสินค้า';
                  }
                  return null;
                },
                items: <String>[
                  'ของสด',
                  'ของแห้ง',
                  'เครื่องปรุง',
                  'อื่นๆ',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "ปริมาณ (กก.)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  try {
                    if (value!.isNotEmpty) {
                      if (double.parse(value) >= 0) {
                        return null;
                      }
                    }
                    throw ("กรุณาใส่ปริมาณสินค้าที่ถูกต้อง");
                  } catch (e) {
                    return "กรุณาใส่ปริมาณสินค้า";
                  }
                },
                controller: amountController,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Create transaction data
                    TransactionItem transaction = TransactionItem(
                      item_id: id,
                      item_name: itemNameController.text,
                      item_type: typeController.text,
                      item_amount: int.tryParse(amountController.text) ?? 0,
                      date_added: DateTime.now().toIso8601String(),
                      date_expired:
                          (DateTime.now().add(const Duration(days: 3)))
                              .toIso8601String(),
                    );

                    try {
                      // Add data to Firestore
                      final addData = FirebaseFirestore.instance
                          .collection('stock_check')
                          .doc(id);
                      await addData.set(transaction.toMap());
                      // Data added successfully
                      Navigator.pop(context);
                    } catch (e) {
                      // Error occurred while adding data
                      print('Error adding data to Firestore: $e');
                      // Handle error appropriately, e.g., show a snackbar or dialog
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 252, 162, 28), // สีที่คุณต้องการ
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  "เพิ่มข้อมูล",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
