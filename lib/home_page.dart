import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';
import 'package:mookata/qrcode/callqrcode.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/profile/profile.dart';
import 'package:mookata/Stock_check/Stock_check.dart';
import 'package:mookata/qrcode/AdminCall.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data();
        });
      }
    }
  }

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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 206, 142),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'LA-DAปิ้งย่างซีฟู้ด',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color.fromARGB(255, 0, 0, 0), // เพิ่มสีขาว
                        ),
                      ),
                      if (_userData != null)
                        Text(
                          'ยินดีต้อนรับ, คุณ ${_userData!['name']}',
                          style: TextStyle(fontSize: 20),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReviewPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 100), // กำหนดขนาดปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // กำหนดรูปร่างของปุ่มเป็นสี่เหลี่ยม
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rate_review,
                              size: 40,
                              color: Colors.orange), // เปลี่ยนสีไอคอนเป็นสีส้ม
                          SizedBox(height: 5),
                          Text('รีวิว',
                              style: TextStyle(fontSize: 12)), // ชื่อปุ่ม
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => goToEmployeeCallForm(context),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 100), // กำหนดขนาดปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // กำหนดรูปร่างของปุ่มเป็นสี่เหลี่ยม
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call,
                              size: 40,
                              color: Colors.orange), // เปลี่ยนสีไอคอนเป็นสีส้ม
                          SizedBox(height: 5),
                          Text('เรียกพนักงาน',
                              style: TextStyle(fontSize: 12)), // ชื่อปุ่ม
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'โปรโมชั่นแนะนำ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
            // Buttons for various actions
          ],
        ),
      ),
    );
  }
}
