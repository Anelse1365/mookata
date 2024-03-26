import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;
  TextEditingController _commentController = TextEditingController();

  Future<void> _submitRating() async {
    // สร้าง collection "ratings" ใน Firestore
    CollectionReference ratings = FirebaseFirestore.instance.collection('ratings');

    try {
      // เพิ่มเอกสารใหม่ (document) ที่มีข้อมูลคะแนนและความคิดเห็น
      await ratings.add({
        'rating': _rating,
        'comment': _commentController.text, // เพิ่มความคิดเห็น
        'timestamp': DateTime.now(), // เพิ่ม timestamp เพื่อบันทึกเวลา
      });
      // แสดงแจ้งเตือนว่าบันทึกคะแนนเรียบร้อย
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your rating has been submitted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // หากมีข้อผิดพลาดในการบันทึกข้อมูล
      print('Error submitting rating: $e');
      // แสดงแจ้งเตือนว่ามีข้อผิดพลาดเกิดขึ้น
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit rating. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Rating'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'โปรดให้คะแนน',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 1 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 2 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 3 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 4 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 5 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 5;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // ช่อง comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'แสดงความคิดเห็น (ไม่บังคับ)',
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _rating == 0 ? null : _submitRating,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
