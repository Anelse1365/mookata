import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallQRCodeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการเรียกพนักงาน'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('calls').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('เลขโต๊ะ: ${data['tableNumber']}'),
                  subtitle: Text('บริการ: ${data['services'].join(', ')}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete the document from Firestore
                      FirebaseFirestore.instance.collection('calls').doc(document.id).delete();
                    },
                  ),
                  onTap: () {
                    // Navigate to the detail page (callqrcode.dart)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallQRCodeDetail(
                          tableNumber: data['tableNumber'],
                          services: data['services'],
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CallQRCodeDetail extends StatelessWidget {
  final String tableNumber;
  final List<dynamic> services;

  const CallQRCodeDetail({
    required this.tableNumber,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดการเรียกพนักงาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'เลขโต๊ะ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              tableNumber,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'บริการ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              services.join(', '),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CallQRCodeList(),
  ));
}
