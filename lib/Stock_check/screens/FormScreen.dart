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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Input"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "ชื่อวัตถุดิบ"),
              autofocus: true,
              validator: (str) {
                if(str!.isEmpty){
                  return "กรุณาใส่ชื่อวัตถุดิบ";
                }
                return null;
              },
              controller: itemNameController,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'ประเภทวัตถุดิบ'),
              value: _selectedIngredientType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIngredientType = newValue;
                  typeController.text = newValue!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'กรุณาเลือกประเภทวัตถุดิบ';
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
            TextFormField(
              decoration: const InputDecoration(labelText: "ปริมาณวัตถุดิบ(KG)"),
              keyboardType: TextInputType.number,
              validator: (value) {
                try{
                  if(value!.isNotEmpty){
                    if(double.parse(value) >= 0){
                      return null;
                    }
                  }throw();
                }catch(e){
                  return "กรุณาใส่ปริมาณวัตถุดิบ";
                }
              },
              controller: amountController,
            ),
      
            TextButton(
              onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Create transaction data
                TransactionItem transaction = TransactionItem(
                  item_id: id,
                  item_name: itemNameController.text,
                  item_type: typeController.text, // Update with selected ingredient type
                  item_amount: int.tryParse(amountController.text) ?? 0, // Parse size as integer or default to 0
                  date_added: DateTime.now().toIso8601String(),
                  date_expired: (DateTime.now().add(const Duration(days: 3))).toIso8601String(),
                );

                try {
                  // Add data to Firestore
                  final addData = FirebaseFirestore.instance.collection('stock_check').doc(id);
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
              child: Text(
                "เพิ่มข้อมูล", 
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
