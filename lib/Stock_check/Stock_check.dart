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
        backgroundColor: Color.fromARGB(255, 252, 162, 28),
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormScreen(),
                ),
              );
            },
            icon: const Text(
              "+",
              style: TextStyle(fontSize: 30.0),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('stock_check').snapshots(),
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
          return SingleChildScrollView(
            child: DataTable(
              columnSpacing: 5, // ระยะห่างระหว่างคอลัมน์
              dataRowHeight: 60, // ความสูงของแถว
              headingRowHeight: 40, // ความสูงของหัวคอลัมน์
              columns: const [
                DataColumn(
                  label: Text(
                    'กก.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ชื่อวัตถุดิบ',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Exp',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'แก้ไขหรือลบ',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
              rows: data.map((item) {
                final itemData = TransactionItem.fromMap(
                    item.data() as Map<String, dynamic>);
                return DataRow(
                  cells: [
                    DataCell(
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.amber,
                        child: Text(
                          itemData.item_amount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        itemData.item_name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        'Exp: ${itemData.date_expired.toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FormEditScreen(data: itemData),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 20),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('stock_check')
                                  .doc(itemData.item_id)
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
