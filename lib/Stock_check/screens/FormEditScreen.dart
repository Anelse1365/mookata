
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Edit Transaction"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "ชื่อวัตถุดิบ"),
              autofocus: true,
              validator: (str) {
                if (str!.isEmpty) {
                  return "กรุณาใส่ชื่อวัตถุดิบ";
                }
                return null;
              },
              controller: itemNameController,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'ประเภทวัตถุดิบ'),
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
            TextFormField(
              decoration: const InputDecoration(labelText: "ปริมาณวัตถุดิบ(KG)"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "กรุณาใส่ปริมาณวัตถุดิบ";
                }
                return null;
              },
              controller: amountController,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Update transaction data
                  widget.data.item_name = itemNameController.text;
                  widget.data.item_type = typeController.text;
                  widget.data.item_amount = int.tryParse(amountController.text) ?? 0;
                  widget.data.date_added = DateTime.now().toIso8601String();
                  widget.data.date_expired = (DateTime.now().add(const Duration(days: 3))).toIso8601String();
                  
                  try {
                    // Update transaction in Firestore
                    await FirebaseFirestore.instance.collection('stock_check').doc(widget.data.item_id).update(widget.data.toMap());

                    // Data updated successfully
                    Navigator.pop(context);
                  } catch (e) {
                    // Error occurred while updating data
                    print('Error updating data in Firestore: $e');
                    // Handle error appropriately, e.g., show a snackbar or dialog
                  }
                }
              },
              child: Text("บันทึกการเปลี่ยนแปลง"),
            ),
          ],
        ),
      ),
    );
  }
}
