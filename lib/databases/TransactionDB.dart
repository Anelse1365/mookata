import 'dart:ffi';
import 'dart:io';
import 'package:flutter_database/models/TransactionItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB{

  String dbName;
  //account1.db

  TransactionDB(this.dbName);

  Future<Database> openDatabase() async{
    Directory appDirectory = await getApplicationDocumentsDirectory();

    String dbLocation = join(appDirectory.path, dbName);
    
    //create db
    DatabaseFactory dbFactory = databaseFactoryIo;
    Future<Database> db = dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(TransactionItem trans) async{
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    var keyId = await store.add(db, {
      "title": trans.title,
      "amount": trans.amount,
      "date": trans.date
    });
    print("$keyId");
    db.close();
    return keyId;
  }

  Future<List<TransactionItem>> loadAllData() async{
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    var snapshot = await store.find(
      db, 
      finder: Finder(sortOrders: [SortOrder('date', false)])
    );
    print("All data: $snapshot");

    List<TransactionItem> transactions = [];

    for ( var item in snapshot){
      int id = item.key;
      String title = item['title'].toString();
      double amount = double.parse(item['amount'].toString());
      String date = item['date'].toString();

      TransactionItem trans = TransactionItem(id: id, title: title, amount: amount, date: date);

      transactions.add(trans);
    }
    db.close();
    return transactions;
  }

  deleteData(TransactionItem trans) async{
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    print("Statement id is ${trans.id}");

    //filter with 'id'
    final finder = Finder(filter: Filter.byKey(trans.id));
    print(finder);

    var deleteResult = await store.delete(db, finder: finder);
    print("$deleteResult row(s) deleted.");
    db.close();
  }

  updateData(TransactionItem trans) async{
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    print("Item key id: ${trans.id}");

    final finder = Finder(filter: Filter.byKey(trans.id));
    print(finder);

    var updateResult = await store.update(db, trans.toMap(), finder: finder);
    print("$updateResult has been updated.");
    db.close();
  }

}