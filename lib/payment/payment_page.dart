import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final CollectionReference<Map<String, dynamic>> reservationsCollection;

  const PaymentPage({
    Key? key,
    required this.firestore,
    required this.reservationsCollection,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? selectedTable;
  int? numberOfPeople;
  double totalAmount = 0;
  double additionalFee = 0; // ค่าปรับเพิ่มเติม

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<int>(
              value: selectedTable,
              onChanged: (value) {
                setState(() {
                  selectedTable = value;
                  loadTableData();
                });
              },
              items: List.generate(
                20,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('Table ${index + 1}'),
                ),
              ),
              decoration: InputDecoration(
                labelText: 'Select Table',
              ),
            ),
            SizedBox(height: 20),
            if (numberOfPeople != null)
              Text(
                'Number of People: $numberOfPeople',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Additional Fee',
              ),
              onChanged: (value) {
                setState(() {
                  additionalFee = double.tryParse(value) ?? 0;
                  calculateTotalAmount();
                });
              },
            ),
            SizedBox(height: 20),
            if (totalAmount != 0)
              Text(
                'Total Amount: $totalAmount Baht',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> loadTableData() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await widget.reservationsCollection.get();

    // ตรวจสอบว่ามีข้อมูลในฐานข้อมูลหรือไม่
    if (snapshot.docs.isNotEmpty) {
      bool foundTableData = false; // ตัวแปรช่วยตรวจสอบว่าพบข้อมูลของโต๊ะที่เลือกหรือไม่

      for (var doc in snapshot.docs) {
        if (doc.data()['table_number'] == selectedTable) {
          int numberOfPeople = doc.data()['number_of_people'];
          setState(() {
            this.numberOfPeople = numberOfPeople;
            calculateTotalAmount();
          });
          foundTableData = true; // พบข้อมูลของโต๊ะที่เลือก
          break;
        }
      }

      // ถ้าไม่พบข้อมูลของโต๊ะที่เลือก ให้รีเซ็ตค่า
      if (!foundTableData) {
        setState(() {
          numberOfPeople = null;
          totalAmount = 0;
        });
      }
    } else {
      // ถ้าไม่มีข้อมูลในฐานข้อมูล ให้รีเซ็ตค่า
      setState(() {
        numberOfPeople = null;
        totalAmount = 0;
      });
    }
  } catch (e) {
    print('Error loading table data: $e');
  }
}

  void calculateTotalAmount() {
    if (numberOfPeople != null) {
      totalAmount = (numberOfPeople! * 159.0) + additionalFee;
    } else {
      totalAmount = additionalFee;
    }
  }
}