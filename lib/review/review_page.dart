import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import package สำหรับ Firebase Authentication

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _rating = 0;
  TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // ประกาศตัวแปร _auth สำหรับ Firebase Authentication

  Future<void> _submitRating() async {
    String? currentUserEmail;
    try {
      // ได้รับ email ของผู้ใช้งานปัจจุบัน
      final User? currentUser = _auth.currentUser;
      currentUserEmail = currentUser?.email;
    } catch (e) {
      print('Error getting current user email: $e');
    }

    // สร้าง collection "ratings" ใน Firestore
    CollectionReference ratings = FirebaseFirestore.instance.collection('ratings');

    try {
      // เพิ่มเอกสารใหม่ (document) ที่มีข้อมูลคะแนน, ความคิดเห็น และ email ของผู้รีวิว
      await ratings.add({
        'rating': _rating,
        'comment': _commentController.text,
        'reviewerEmail': currentUserEmail, // เพิ่มฟิลด์ email ของผู้รีวิว
        'timestamp': DateTime.now(),
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
      body: Column(
        children: [
          Expanded(
            child: Center(
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
                      // ... (รหัสสำหรับแสดง IconButton ดาวอีก 4 ดวง)
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
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('ratings').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No ratings yet.'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var ratingData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    var rating = ratingData['rating'];
                    var comment = ratingData['comment'];
                    var timestamp = ratingData['timestamp'];
                    var reviewerEmail = ratingData['reviewerEmail'] ?? 'Anonymous'; // ถ้า reviewerEmail เป็น null จะแสดง 'Anonymous'

                    // แปลง timestamp เป็นวันเวลาในรูปแบบข้อความ
                    var formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        elevation: 4.0,
                        child: ListTile(
                          leading: Text(
                            'Rating: $rating',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            'Comment:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$comment'),
                              SizedBox(height: 4),
                              Text(
                                'Reviewer: $reviewerEmail',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '$formattedTimestamp',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              rating.toInt(),
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}