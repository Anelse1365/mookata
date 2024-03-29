import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mookata/Auth/login.dart';
import 'package:mookata/admin_home_page.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // ตรวจสอบบทบาทของผู้ใช้
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasData) {
                  // ผู้ใช้ได้ล็อกอินและมีข้อมูล
                  final userData = userSnapshot.data!;
                  final role = userData.get('role');
                  if (role == 'admin') {
                    // ผู้ใช้เป็น Admin
                    return AdminHomePage();
                  } else {
                    // ผู้ใช้เป็น User
                    return HomePage();
                  }
                } else {
                  // ไม่พบข้อมูลผู้ใช้
                  return Center(child: Text('No user data found'));
                }
              },
            );
          } else {
            // ผู้ใช้ยังไม่ได้ล็อกอิน
            return LoginPage();
          }
        },
      ),
    );
  }
}
