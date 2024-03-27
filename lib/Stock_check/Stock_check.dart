import 'package:flutter/material.dart';
import 'TransactionItem.dart';
import 'screens/FormEditScreen.dart';
import 'screens/FormScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Stock_check(title: 'ตรวจสอบวันหมดอายุ'),
    );
  }
}

class Stock_check extends StatelessWidget {
  const Stock_check({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FormScreen();
              }));
            },
            icon: const Text(
              "+",
              style: TextStyle(fontSize: 30.0),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stock_check').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }
          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No Data.",
                style: TextStyle(fontSize: 30),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = TransactionItem.fromMap(data[index].data() as Map<String, dynamic>);
              return Card(
                elevation: 10,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text("${item.item_amount}"),
                  ),
                  title: Text(item.item_name),
                  subtitle: Text(item.date_added.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('stock_check').doc(item.item_id).delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FormEditScreen(data: item);
                    }));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
