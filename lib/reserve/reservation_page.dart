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
  }

  Future<void> _reserveTable() async {
    try {
      // Check if the selected table is already reserved
      QuerySnapshot<Map<String, dynamic>> reservationQuery = await widget
          .reservationsCollection
          .where('table_number', isEqualTo: selectedTable)
          .where('reserv_state', isEqualTo: 0) // Check if the table is available
          .get();

      if (reservationQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Table is not available for reservation')));
        return;
      }

      // If the table is available, add data to Firestore
      await widget.reservationsCollection.add({
        'table_number': selectedTable,
        'number_of_people': numberOfPeople,
        'time': selectedTime.format(context),
        'date': selectedDate,
        'reserv_state': 1, // Set reservation state to 1 (reserved)
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Table reserved successfully')));
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