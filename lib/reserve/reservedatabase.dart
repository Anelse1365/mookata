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
  late Database _database;

  @override
  void initState() {
    super.initState();
    _database = widget.database;
  }

  Future<List<Map<String, dynamic>>> getReservations() async {
    final records = await widget.store.find(_database);
    return records.map((record) => record.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Reservation'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final reservations = snapshot.data!;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ListTile(
                  title: Text('Date: ${reservation['date']}'),
                  subtitle: Text('Time: ${reservation['time']}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the reservation page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationPage(
                database: _database,
                store: widget.store,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
