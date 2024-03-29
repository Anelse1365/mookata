import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mookata/reservation_page.dart';
import 'package:mookata/reserve/reservation_page.dart';

class BookingPickTablePage extends StatefulWidget {
  @override
  _BookingPickTablePageState createState() => _BookingPickTablePageState();
}

class _BookingPickTablePageState extends State<BookingPickTablePage> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Bookings'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('reservations').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // เก็บสถานะการจองของโต๊ะไว้ใน Map
          Map<int, int> tableStates = {};
          snapshot.data!.docs.forEach((doc) {
            tableStates[doc['table_number']] = doc['reserv_state'];
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    int tableNumber = index + 1;
                    int? reservState = tableStates[tableNumber];
                    int? reservState2 = tableStates[tableNumber];
                    bool isSelected = selectedTable == tableNumber;

                    // กำหนดสีของโต๊ะตามสถานะการจอง
                    Color tableColor =
                        reservState == 1 ? Colors.grey : Colors.orange;

                    // ตรวจสอบว่าโต๊ะยังไม่ได้จองและไม่ได้เลือก
                    bool canSelect = reservState2 == 0;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (canSelect) {
                            setState(() {
                              selectedTable = isSelected ? null : tableNumber;
                            });
                            if (selectedTable != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReservationPage(
                                    firestore: FirebaseFirestore.instance,
                                    reservationsCollection: FirebaseFirestore
                                        .instance
                                        .collection('reservations'),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : tableColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              tableNumber.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'รายละเอียดการจองโต๊ะ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '- โต๊ะ 1 ตัว มีทั้งหมด 4 ที่นั่ง',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '- 1 บัญชีสามารถจองได้สูงสุด 5 โต๊ะ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
