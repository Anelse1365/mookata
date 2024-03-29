import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';
import 'package:mookata/reserve/reservation_page.dart';
import 'package:mookata/payment/payment.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/profile/profile.dart';
import 'package:mookata/Stock_check/Stock_check.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key})
      : super(
            key:
                key); // Provide a non-null default value for the 'key' parameter

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
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
              reservationsCollection: firestore.collection('reservations'))),
    );
  }

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
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
        child: _getPage(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_restaurant_sharp), label: 'Table'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePageContent();
      case 1:
        return BookingPickTablePage();
      case 2:
        return Text('Profile');
      default:
        return Container();
    }
  }

  Widget _buildHomePageContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => addUser(context),
          child: Text('Add User and Open Reservation Page'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => goToPayment(context),
          child: Text('Go to Payment'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: Text('Review'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          child: Text('Profile'),
        ),
        ElevatedButton(
          onPressed: () => goToBooking(context),
          child: Text('Booking'),
        ),
        ElevatedButton(
          onPressed: () => goToStock(context),
          child: Text('Go to Stock Check'),
        ),
      ],
    );
  }
}
