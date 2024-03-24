import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final CollectionReference<Map<String, dynamic>> reservationsCollection;

  const ReservationPage({
    Key? key,
    required this.firestore,
    required this.reservationsCollection,
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
    selectedTable = 1;
    numberOfPeople = 1;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> _reserveTable() async {
    try {
      await widget.reservationsCollection.add({
        'table_number': selectedTable,
        'number_of_people': numberOfPeople,
        'time': selectedTime.format(context),
        'date': selectedDate,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Table reserved successfully')));
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
              items: List.generate(10, (index) => DropdownMenuItem<int>(value: index + 1, child: Text('Table ${index + 1}'))),
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
                final pickedDate = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
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
                final pickedTime = await showTimePicker(context: context, initialTime: selectedTime);
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
  CollectionReference<Map<String, dynamic>> reservationsCollection = firestore.collection('reservations');

  runApp(ReservationPage(
    firestore: firestore, 
    reservationsCollection: reservationsCollection,
  ));
}
