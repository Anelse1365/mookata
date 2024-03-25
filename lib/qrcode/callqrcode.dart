import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class EmployeeCallForm extends StatefulWidget {
  @override
  _EmployeeCallFormState createState() => _EmployeeCallFormState();
}

class _EmployeeCallFormState extends State<EmployeeCallForm> {
  String tableNumber = '';
  List<String> services = [];
  String qrCodeResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ฟอร์มเรียกพนักงาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'เลขโต๊ะ: ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  tableNumber = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'เลือกบริการ:',
              style: TextStyle(fontSize: 16),
            ),
            CheckboxListTile(
              title: Text('เติมถ่าน'),
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
              title: Text('เปลี่ยนกระทะ'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                callEmployee();
              },
              child: Text('ยืนยันการเรียกพนักงาน'),
            ),
          ],
        ),
      ),
    );
  }

  void callEmployee() {
    // Ensure that services is not null before accessing its value
    List<String> selectedServices = services ?? [];
    // Here you can implement the logic to call the employee
    // You can use qrCodeResult, tableNumber, and selectedServices list to determine the request
    // For example, you can send a request to a server or display a notification to the employee
    // This function will be called when the user taps on the "Call Employee" button
    print('Calling employee...');
    print('QR Code Result: $qrCodeResult');
    print('Table Number: $tableNumber');
    print('Selected Services: $selectedServices');
    // Concatenate the phone number with the appropriate scheme (tel:)
    String phoneNumber = '1234567890'; // Replace this with the actual phone number
    String url = 'tel:$phoneNumber';
    // Call the phone number using the url_launcher package
    launch(url);
  }
}

void main() {
  runApp(MaterialApp(
    home: EmployeeCallForm(),
  ));
}