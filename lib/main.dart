import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mookata/Auth/login.dart';
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
            // ผู้ใช้ได้ล็อกอินแล้ว
            return HomePage();
          } else {
            // ผู้ใช้ยังไม่ได้ล็อกอิน
            return LoginPage();
          }
        },
      ),
    );
  }
}