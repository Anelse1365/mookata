import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'reserve/reserve.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await databaseFactoryWeb.openDatabase('reservation_database.db');
  final store = intMapStoreFactory.store('reservations');
  runApp(MyApp(database: database, store: store));
}

class MyApp extends StatelessWidget {
  final Database database;
  final StoreRef<int, Map<String, dynamic>> store;

  const MyApp({Key? key, required this.database, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReservationPage(database: database, store: store), 
    );
  }
}


