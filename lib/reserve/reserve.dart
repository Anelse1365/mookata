import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ReservationPage extends StatefulWidget {
  final Database database;
  final StoreRef<int, Map<String, dynamic>> store;

  const ReservationPage({Key? key, required this.database, required this.store}) : super(key: key);

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
    _openDatabase(); // Call _openDatabase to initialize _database
  }

  Future<void> _openDatabase() async {
    _database = widget.database; // Use the provided database
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
          title: const Text('Reservation Successful'),
          content: const Text('Your reservation has been successfully placed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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

  void _viewReservations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewReservationsPage(database: _database, store: widget.store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Reservation'),
        actions: [
          IconButton(
            onPressed: _viewReservations,
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _numberOfPeopleController,
              decoration: const InputDecoration(labelText: 'Number of People'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _contactInfoController,
              decoration: const InputDecoration(labelText: 'Contact Information'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitReservation,
              child: const Text('Submit Reservation'),
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

class ViewReservationsPage extends StatelessWidget {
  final Database database;
  final StoreRef<int, Map<String, dynamic>> store;

  const ViewReservationsPage({Key? key, required this.database, required this.store}) : super(key: key);

  Future<List<Map<String, dynamic>>> getReservations() async {
    final records = await store.find(database);
    return records.map((record) => record.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reservations'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ListTile(
                  title: Text('Date: ${reservation['date']}'),
                  subtitle: Text('Time: ${reservation['time']}'),
                  // You can add more information here as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
