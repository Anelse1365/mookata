import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'reserve/reserve.dart'; // ต้องแก้ไขตามโครงสร้างของโปรเจคของคุณ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final databasePath = appDocumentDir.path;
  final database = await databaseFactoryIo.openDatabase('$databasePath/reservation_database.db');
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
