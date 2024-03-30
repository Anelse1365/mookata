import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeCallForm extends StatefulWidget {
  @override
  _EmployeeCallFormState createState() => _EmployeeCallFormState();
}

class _EmployeeCallFormState extends State<EmployeeCallForm> {
  String tableNumber = '';
  List<String> services = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ฟอร์มเรียกพนักงาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'เลขโต๊ะ: ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  tableNumber = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'เลือกบริการ:',
              style: TextStyle(fontSize: 16),
            ),
            CheckboxListTile(
              title: const Text('เติมถ่าน'),
              value: services.contains('เติมถ่าน'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    services.add('เติมถ่าน');
                  } else {
                    services.remove('เติมถ่าน');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('เปลี่ยนกระทะ'),
              value: services.contains('เปลี่ยนกระทะ'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    services.add('เปลี่ยนกระทะ');
                  } else {
                    services.remove('เปลี่ยนกระทะ');
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                callEmployee();
                Navigator.pop(context); // กลับไปยังหน้าหลัก
              },
              child: const Text('ยืนยันการเรียกพนักงาน'),
            ),
          ],
        ),
      ),
    );
  }

  void callEmployee() async {
    // Check if user is signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where user is not signed in
      print('User is not signed in');
      return;
    }

    // Get the current user's ID
    String userId = user.uid;

    // Create a reference to the Firestore collection
    CollectionReference callCollection =
        FirebaseFirestore.instance.collection('calls');

    // Add a new document with a generated ID
    await callCollection.add({
      'userId': userId,
      'tableNumber': tableNumber,
      'services': services,
      'timestamp': DateTime.now(),
    });

    print('Call data sent to Firestore');
  }
}

void main() {
  runApp(MaterialApp(
    home: EmployeeCallForm(),
  ));
}
