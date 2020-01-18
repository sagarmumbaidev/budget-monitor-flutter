import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:money_monitor/model/transaction.dart';
import 'package:money_monitor/model/category.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'budget_monitor.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(join(documentsDirectory.path));
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE transactions ("
        "id INTEGER PRIMARY KEY, "
        "amount DOUBLE, "
        "description TEXT,"
        "transaction_type TEXT)");
    /* await db.execute("CREATE TABLE categories ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT");
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO categories (name) VALUES ('food'),('travel')";
      //print(await txn.rawInsert(query));
      return await txn.rawInsert(query);
    });*/
  }

  Future<MoneyTransaction> save(MoneyTransaction mt) async {
    var dbClient = await db;
    mt.id = await dbClient.insert('transactions', mt.toMap());
    return mt;
    /*await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NOTE) VALUES ('" + mt.note + "')";
      //print(await txn.rawInsert(query));
      return await txn.rawInsert(query);
    });*/
  }

  Future<List<MoneyTransaction>> getTransactions() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NOTE]);
    var result = await dbClient.rawQuery("SELECT * FROM transactions");
    if (result.length == 0) return null;
    List<MoneyTransaction> list = result.map((row) {
      return MoneyTransaction.fromMap(row);
    }).toList();
    return list;
  }

  /*Future<List<Category>> getCategories() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NOTE]);
    var result = await dbClient.rawQuery("SELECT * FROM categories");
    if (result.length == 0) return null;
    List<Category> list = result.map((row) {
      return Category.fromMap(row);
    }).toList();
    return list;
  }*/

  /*Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(),
        where: '$ID = ?', whereArgs: [employee.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }*/
}
