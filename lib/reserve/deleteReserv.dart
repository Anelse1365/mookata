import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageReservationsPage extends StatefulWidget {
  final FirebaseFirestore firestore;
  final CollectionReference<Map<String, dynamic>> reservationsCollection;

  const ManageReservationsPage({
    Key? key,
    required this.firestore,
    required this.reservationsCollection,
  }) : super(key: key);

  @override
  _ManageReservationsPageState createState() => _ManageReservationsPageState();
}

class _ManageReservationsPageState extends State<ManageReservationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.reservationsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reservations found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reservation = snapshot.data!.docs[index].data();
              return ListTile(
                title: Text('Table ${reservation['table_number']}'),
                subtitle: Text('Date: ${reservation['date'].toString()}, Time: ${reservation['time'].toString()}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteReservation(reservation['table_number']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteReservation(int tableNumber) async {
    try {
      await widget.reservationsCollection.doc(tableNumber.toString()).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reservation deleted successfully')));
    } catch (e) {
      print('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete reservation')));
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> reservationsCollection =
      firestore.collection('reservations');

  runApp(ManageReservationsPage(
    firestore: firestore,
    reservationsCollection: reservationsCollection,
  ));
}
