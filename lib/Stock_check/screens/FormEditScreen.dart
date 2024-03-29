import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../TransactionItem.dart';

class FormEditScreen extends StatefulWidget {
  final TransactionItem data;

  const FormEditScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<FormEditScreen> createState() => _FormEditScreenState();
}

class _FormEditScreenState extends State<FormEditScreen> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final typeController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values from provided data
    itemNameController.text = widget.data.item_name;
    typeController.text = widget.data.item_type;
    amountController.text = widget.data.item_amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 162, 28),
        title: Text("แก้ไขข้อมูล"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "ชื่อวัตถุดิบ",
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (str) {
                  if (str!.isEmpty) {
                    return "กรุณาใส่ชื่อวัตถุดิบ";
                  }
                  return null;
                },
                controller: itemNameController,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'ประเภทวัตถุดิบ',
                  border: OutlineInputBorder(),
                ),
                value: typeController.text,
                onChanged: (String? newValue) {
                  setState(() {
                    typeController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "ปริมาณวัตถุดิบ(KG)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาใส่ปริมาณวัตถุดิบ";
                  }
                  return null;
                },
                controller: amountController,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Update transaction data
                    widget.data.item_name = itemNameController.text;
                    widget.data.item_type = typeController.text;
                    widget.data.item_amount =
                        int.tryParse(amountController.text) ?? 0;
                    widget.data.date_added = DateTime.now().toIso8601String();
                    widget.data.date_expired =
                        (DateTime.now().add(const Duration(days: 3)))
                            .toIso8601String();

                    try {
                      // Update transaction in Firestore
                      await FirebaseFirestore.instance
                          .collection('stock_check')
                          .doc(widget.data.item_id)
                          .update(widget.data.toMap());

                      // Data updated successfully
                      Navigator.pop(context);
                    } catch (e) {
                      // Error occurred while updating data
                      print('Error updating data in Firestore: $e');
                      // Handle error appropriately, e.g., show a snackbar or dialog
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Set your desired background color here
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  "บันทึกการเปลี่ยนแปลง",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
