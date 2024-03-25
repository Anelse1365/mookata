import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mookata/main.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
import 'callqrcode.dart'; // Import callqrcode.dart

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.purple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyHomePage(title: 'เรียกพนักงาน'),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scanresult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startScan,
                child: Text('Scan QR Code'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the callqrcode.dart screen when the button is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeCallForm()),
                  );
                },
                child: Text('เรียกพนักงาน'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startScan() async {
    String? cameraScanResult = await scanner.scan();
    setState(() {
      scanresult = cameraScanResult ?? '';
    });
  }
}
