import 'package:flutter/foundation.dart';
import 'package:flutter_database/databases/transactionDB.dart';
import 'package:flutter_database/models/TransactionItem.dart';
import 'package:sembast/sembast.dart';

class TransactionProvider with ChangeNotifier{

  String dbName = 'transaction2.db';
  List<TransactionItem> transactions = [];

  List<TransactionItem> getTransaction(){
    return transactions;
  }

  

  void addTransaction(TransactionItem trans) async {
    //insert data into database
    TransactionDB db = TransactionDB(dbName);
    int keyId = await db.insertData(trans);

    // load data from db
    transactions = await db.loadAllData();

    //insert TransactionItem into list
    // transactions.insert(0,trans);
    notifyListeners();
  }

  Future<List<TransactionItem>> loadAllData() async{
    TransactionDB db = TransactionDB(dbName);
    return await db.loadAllData();
  }
  
  void initAllData() async {
    TransactionDB db = TransactionDB(dbName);
    
    transactions = await db.loadAllData();
    notifyListeners();
  }
  
  deleteData(TransactionItem trans) async{
    TransactionDB db = TransactionDB(dbName);
    await db.deleteData(trans);
  }

  updateTransaction(TransactionItem trans) async{
    TransactionDB db = TransactionDB(dbName);
    print("Provider Item id: ${trans.id}");
    
    await db.updateData(trans);
    notifyListeners();
  }
}