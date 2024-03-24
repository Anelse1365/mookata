import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Firestore Example',
     home: HomePage(),
   );
 }
}

class HomePage extends StatefulWidget {
 @override
 _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final firestore = FirebaseFirestore.instance;

 Future<void> addData(String collectionName, Map<String, dynamic> data) async {
   try {
     await firestore.collection(collectionName).add(data);
   } catch (e) {
     print('Error adding data: $e');
   }
 }

 void addUser() {
   final userData = {
     'name': 'John Doe',
     'age': 30,
     'city': 'New York',
   };

   addData('users', userData);
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Firestore Example'),
     ),
     body: Center(
       child: ElevatedButton(
         onPressed: addUser,
         child: Text('Add User'),
       ),
     ),
   );
 }
}