// register_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // ฟังก์ชันสร้างบัญชีผู้ใช้
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
              child: Text('Register'),
            ),
            TextButton(
             onPressed: () {
               // ไปที่หน้า Register
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => LoginPage()),
               );
             },
             child: Text('back to login'),
           ),
          ],
        ),
      ),
    );
  }
}