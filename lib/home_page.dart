import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/reserve/reservation_page.dart';
import 'package:mookata/payment/payment.dart'; // Import ไฟล์ payment.dart เข้ามา
import 'package:firebase_auth/firebase_auth.dart';

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
      MaterialPageRoute(builder: (context) => ReservationPage(firestore: firestore, reservationsCollection: firestore.collection('reservations'))),
    );
  }

  void goToPayment(BuildContext context) { // เพิ่มฟังก์ชันนี้เพื่อไปยังหน้า Payment
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()), // เรียกใช้งานหน้า PaymentPage
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
              onPressed: () => goToPayment(context), // เรียกใช้งานฟังก์ชัน goToPayment เมื่อคลิก
              child: Text('Go to Payment'), // ตั้งชื่อปุ่มว่า "Go to Payment"
            ),
          ],
        ),
      ),
    );
  }
}

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String PasswordConfirm);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  Future<void> register(
      String email, String password, String PasswordConfirm) async {
    if (PasswordConfirm == password) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        Firestore_Datasource().CreateUser(email);
      });
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Your App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: HomePage(),
  ));
}
