import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final CollectionReference<Map<String, dynamic>> reservationsCollection;
  final int selectedTable; // เพิ่มพารามิเตอร์สำหรับรับหมายเลขโต๊ะที่ถูกเลือก

  const ReservationPage({
    Key? key,
    required this.firestore,
    required this.reservationsCollection,
    required this.selectedTable, // รับค่าหมายเลขโต๊ะที่ถูกเลือก
  }) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late int selectedTable;
  late int numberOfPeople;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTable = widget.selectedTable; // ใช้ selectedTable ที่รับค่ามาจาก parameter
    numberOfPeople = 1;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    // เรียกฟังก์ชันเพื่ออัปเดตค่า selectedTable
    updateSelectedTable();
  }

  // ฟังก์ชันสำหรับอัปเดตค่า selectedTable จากฐานข้อมูล
  Future<void> updateSelectedTable() async {
    // ค้นหาข้อมูลการจองโต๊ะจากฐานข้อมูล
    DocumentSnapshot<Map<String, dynamic>> tableDoc = await widget.reservationsCollection
        .doc(selectedTable.toString())
        .get();

    // ตรวจสอบว่าโต๊ะที่เลือกมีการจองหรือไม่
    if (tableDoc.exists) {
      int reservState = tableDoc['reserv_state'];

      // ถ้าโต๊ะมีการจอง ให้อัปเดตค่า selectedTable ให้เป็นโต๊ะที่ว่างถัดไป
      if (reservState == 1) {
        await findNextAvailableTable();
      }
    }
  }

  // ฟังก์ชันสำหรับค้นหาโต๊ะที่ว่างถัดไป
  Future<void> findNextAvailableTable() async {
    QuerySnapshot<Map<String, dynamic>> reservationsSnapshot = await widget.reservationsCollection
        .where('reserv_state', isEqualTo: 0)
        .orderBy('table_number')
        .limit(1)
        .get();

    if (reservationsSnapshot.docs.isNotEmpty) {
      setState(() {
        selectedTable = reservationsSnapshot.docs[0]['table_number'];
      });
    }
  }

  // ฟังก์ชันสำหรับการจองโต๊ะ
  Future<void> _reserveTable() async {
  try {
    print('Selected table: $selectedTable'); // แสดงค่าของ selectedTable
    // ตรวจสอบว่าโต๊ะที่เลือกสามารถจองได้หรือไม่
    DocumentSnapshot<Map<String, dynamic>> tableDoc = await widget.reservationsCollection
        .doc(selectedTable.toString())
        .get();

    if (!tableDoc.exists) {
      print('Table ${selectedTable.toString()} does not exist.');
      // เพิ่มโต๊ะที่เลือกลงในฐานข้อมูล
      await widget.reservationsCollection.doc(selectedTable.toString()).set({
        'table_number': selectedTable,
        'number_of_people': numberOfPeople,
        'time': selectedTime.format(context),
        'date': selectedDate,
        'reserv_state': 1, // Set reservation state to 1 (reserved)
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Table reserved successfully')));
    } else if (tableDoc['reserv_state'] == 1) {
      print('Table ${selectedTable.toString()} is already reserved.');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Table is already reserved.')));
      return;
    } else {
      // ถ้าโต๊ะสามารถจองได้ ให้เพิ่มข้อมูลการจองลงในฐานข้อมูล
      await widget.reservationsCollection.doc(selectedTable.toString()).update({
        'number_of_people': numberOfPeople,
        'time': selectedTime.format(context),
        'date': selectedDate,
        'reserv_state': 1, // Set reservation state to 1 (reserved)
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Table reserved successfully')));
    }
  } catch (e) {
    print('Error reserving table: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<int>(
              value: selectedTable,
              onChanged: (value) {
                setState(() {
                  selectedTable = value!;
                });
              },
              items: List.generate(
                  20,
                  (index) => DropdownMenuItem<int>(
                      value: index + 1, child: Text('Table ${index + 1}'))),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of People'),
              onChanged: (value) {
                setState(() {
                  numberOfPeople = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                    context: context, initialTime: selectedTime);
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Select Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reserveTable,
              child: Text('Reserve Table'),
            ),
          ],
        ),  
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> reservationsCollection =
      firestore.collection('reservations');

  runApp(ReservationPage(
    firestore: firestore,
    reservationsCollection: reservationsCollection,
    selectedTable: 1, // กำหนดหมายเลขโต๊ะเริ่มต้นที่ 1
  ));
}
