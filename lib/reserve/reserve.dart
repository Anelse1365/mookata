import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ReservationPage extends StatefulWidget {
  final Database database;
  final StoreRef<int, Map<String, dynamic>> store;

  const ReservationPage({super.key, required this.database, required this.store});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}


class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberOfPeopleController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();

  late Database _database; // Use late modifier

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _database = await databaseFactoryIo.openDatabase('reservation_database.db'); // Initialize _database
  }

  void _submitReservation() async {
    // Get values from text controllers
    String date = _dateController.text;
    String time = _timeController.text;
    int numberOfPeople = int.tryParse(_numberOfPeopleController.text) ?? 0;
    String contactInfo = _contactInfoController.text;

    // Encode reservation data as a Map
    Map<String, dynamic> reservationData = {
      'date': date,
      'time': time,
      'numberOfPeople': numberOfPeople,
      'contactInfo': contactInfo,
    };

    // Save reservation to the database
    await _storeRecord(reservationData);

    // Clear text controllers after submission
    _dateController.clear();
    _timeController.clear();
    _numberOfPeopleController.clear();
    _contactInfoController.clear();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reservation Successful'),
          content: Text('Your reservation has been successfully placed.'),
          actions: <Widget>[
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

  Future<void> _storeRecord(Map<String, dynamic> record) async {
    final store = widget.store;
    await store.add(_database, record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Reservation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _numberOfPeopleController,
              decoration: InputDecoration(labelText: 'Number of People'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _contactInfoController,
              decoration: InputDecoration(labelText: 'Contact Information'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitReservation,
              child: Text('Submit Reservation'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database.close(); // Close the database when the widget is disposed
    super.dispose();
  }
}