import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';
import 'package:mookata/reserve/reservation_page.dart';
import 'package:mookata/payment/payment.dart'; // Import ไฟล์ payment.dart เข้ามา
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/review/review_all.dart';
import 'package:mookata/Stock_check/Stock_check.dart';
import 'package:mookata/profile/profile.dart';


class HomePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addData(String collectionName, Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionName).add(data);
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  void addUser(BuildContext context) {
    final userData = {
      'name': 'John Doe',
      'age': 30,
      'city': 'New York',
    };

    addData('users', userData);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReservationPage(
              firestore: firestore,
              reservationsCollection: firestore.collection('reservations'),
              selectedTable: 1)), // ส่งค่า selectedTable มาให้ ReservationPage
    );
  }

  void goToPayment(BuildContext context) {
    // เพิ่มฟังก์ชันนี้เพื่อไปยังหน้า Payment
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PaymentPage()), // เรียกใช้งานหน้า PaymentPage
    );
  }

  void goToBooking(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookingPickTablePage()));
  }

  void goToStock(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Stock_check(
                title: 'Stock Check',
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => addUser(context),
              child: Text('Add User and Open Reservation Page'),
            ),
            SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () => goToPayment(
                  context), // เรียกใช้งานฟังก์ชัน goToPayment เมื่อคลิก
              child: Text('Go to Payment'), // ตั้งชื่อปุ่มว่า "Go to Payment"
            ),
            SizedBox(height: 20), // เพิ่มระยะห่างระหว่างปุ่ม
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewPage()),
                );
              },
              child: Text('review'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Text('profile'),
            ),
            ElevatedButton(
              onPressed: () => goToBooking(context),
              child: Text('booking'),
            ),
            ElevatedButton(
              onPressed: () => goToStock(context), // Corrected to goToStock
              child: Text('Go to Stock Check'), // Updated button text
            ),
            
          ],
        ),
      ),
    );
  }
}

class Bar extends StatefulWidget {
  const Bar({Key? key});

  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  int currentIndex = 0;
  List widgetOptions = [
    HomePage(),
    PaymentPage(), // แก้ไขจาก BookingPickTablePage() เป็น PaymentPage()
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: 'Payment'), // แก้ไข icon และ label ให้ตรงกับหน้า PaymentPage
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Your App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Bar(), // เรียกใช้ Bar แทน HomePage
  ));
}
