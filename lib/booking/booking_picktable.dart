import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/reservation_page.dart';
import 'package:mookata/reserve/reservation_page.dart'; // นำเข้าไฟล์ reservation_page.dart

class BookingPickTablePage extends StatefulWidget {
  @override
  _BookingPickTablePageState createState() => _BookingPickTablePageState();
}

class _BookingPickTablePageState extends State<BookingPickTablePage> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Bookings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                int tableNumber = index + 1;
                return buildTableWidget(
                    context, tableNumber); // ส่ง context ไปด้วย
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTableWidget(BuildContext context, int tableNumber) {
    bool isSelected = selectedTable == tableNumber;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTable = isSelected ? null : tableNumber;
          });
          if (selectedTable != null) {
            // เมื่อกดแล้วให้เปิดหน้า reservation_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationPage(
                  firestore: FirebaseFirestore
                      .instance, // Firestore จาก Firebase.initializeApp() ที่ได้จาก main()
                  reservationsCollection: FirebaseFirestore.instance.collection(
                      'reservations'), // CollectionReference จาก Firebase.initializeApp() ที่ได้จาก main()
                ),
              ),
            );
          }
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              tableNumber.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
