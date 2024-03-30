import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/booking/booking_picktable.dart';
import 'package:mookata/reserve/reservation_page.dart';
import 'package:mookata/payment/payment_page.dart'; // Import ไฟล์ payment.dart เข้ามา
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mookata/review/review_page.dart';

import 'package:mookata/Stock_check/Stock_check.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Navigate to home
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                // Navigate to about
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
