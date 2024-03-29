import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';
import 'package:mookata/payment/payment.dart';
import 'package:mookata/qrcode/AdminCall.dart';
import 'package:mookata/reserve/deleteReserv.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/profile/profile.dart';
import 'package:mookata/Stock_check/Stock_check.dart'; 

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
  }

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage()),
    );
  }

  void goToBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingPickTablePage()),
    );
  }

  void goToStock(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Stock_check(
          title: 'Stock Check',
        ),
      ),
    );
  }

  void goToDeleteReservationPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ManageReservationsPage(firestore: FirebaseFirestore.instance, reservationsCollection: firestore.collection('reservations'),), // เปลี่ยนเป็น DeleteReservationPage
    ),
  );
}

void goToAdmincall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallQRCodeList(
        ),
      ),
    );
  }

  void goToManageReservationsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageReservationsPage(
          firestore: firestore,
          reservationsCollection: firestore.collection('reservations'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getPage(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home2'),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_restaurant_sharp), label: 'Table2'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile2'),
        ],
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildAdminHomePageContent();
      case 1:
        return BookingPickTablePage();
      case 2:
        return ProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildAdminHomePageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่งตามแนวนอน
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20), // กำหนดระยะห่างด้านซ้าย
          child: Text(
            'Promotions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        CarouselSlider(
          items: [
            Image.asset('assets/ad/ad1.png'),
            Image.asset('assets/ad/ad2.png'),
          ],
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
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
          onPressed: () => goToStock(context),
          child: Text('Go to Stock Check'),
        ),
        ElevatedButton(
          onPressed: () => goToAdmincall(context),
          child: Text('QRCodeCall'),
        ),
        ElevatedButton(
          onPressed: () => goToDeleteReservationPage(context),
          child: Text('Delete Reservations'),
        ),
      ],
    );
  }
}
