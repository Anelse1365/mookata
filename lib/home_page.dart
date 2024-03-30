import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';

import 'package:mookata/qrcode/callqrcode.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/profile/profile.dart';
import 'package:mookata/Stock_check/Stock_check.dart';
import 'package:mookata/qrcode/AdminCall.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ReservationPage(
    //           firestore: firestore,
    //           reservationsCollection: firestore.collection('reservations'))),
    // );
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
        builder: (context) => const Stock_check(
          title: 'Stock Check',
        ),
      ),
    );
  }

  void goToCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CallQRCodeList()),
    );
  }

  void goToEmployeeCallForm(BuildContext context) {
    // เพิ่มฟังก์ชันนี้เพื่อไปยังหน้า EmployeeCallForm
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EmployeeCallForm()), // เรียกใช้งานหน้า EmployeeCallForm
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
        return const ProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildHomePageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่งตามแนวนอน
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20), // กำหนดระยะห่างด้านซ้าย
          child: Text(
            'Promotions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
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
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: const Text('รีวิว'),
        ),
        ElevatedButton(
          onPressed: () => goToBooking(context),
          child: const Text('จองโต๊ะ'),
        ),
        ElevatedButton(
          onPressed: () =>
              goToEmployeeCallForm(context), // Corrected to EmployeeCallForm
          child: const Text('เรียกพนักงาน'), // Updated button text
        ), // EmployeeCallForm
        ElevatedButton(
          onPressed: () => goToCall(context), // Corrected to EmployeeCallForm
          child: const Text('Calling'), // Updated button text
        ),
      ],
    );
  }
}
