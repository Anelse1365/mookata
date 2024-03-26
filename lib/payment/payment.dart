import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = '';

  void _handleSubmit() {
    // ทำอะไรสักอย่างเมื่อกดปุ่ม Submit
    print('Selected payment method: $_selectedPaymentMethod');
    // นำทางไปยังหน้า OKPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OKPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), // ปรับระยะห่างขอบหน้าจอด้านหน้าทั้งสองข้าง
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'กรุณาแจ้งวิธีการชำระเงินของท่านให้พนักงานทราบ', // เพิ่มข้อความหัวข้อ
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              RadioListTile(
                title: Text('เงินสด'),
                value: 'เงินสด',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('Mobile Banking'),
                value: 'Online Banking',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile(
                title: Text('PromptPay'),
                value: 'PromptPay',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              ListTile(
                title: Text('สแกนจ่าย'),
                leading: Icon(Icons.qr_code),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'สแกนจ่าย';
                  });
                },
                selected: _selectedPaymentMethod == 'สแกนจ่าย',
                selectedTileColor: Colors.grey[300],
              ),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OKPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชำระเงิน'),
      ),
      body: Center(
        child: Text('กรุณารอพนักงานมาทำการชำระเงิน..',
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(),
  ));
}
