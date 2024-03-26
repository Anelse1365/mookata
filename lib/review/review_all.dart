import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mookata/review/review_page.dart';
import 'package:mookata/Auth/register_page.dart'; 
import 'package:intl/intl.dart'; // Import package สำหรับการจัดรูปแบบวันเวลา

class ReviewAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: StreamBuilder(
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
                          'Timestamp: $formattedTimestamp',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => ReviewPage()),);},
              child: Text('review'),
      ),
    );
  }
}
