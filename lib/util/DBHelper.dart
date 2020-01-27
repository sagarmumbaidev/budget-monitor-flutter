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
        "transaction_type TEXT,"
        "category_id INTEGER,"
        "transaction_date TEXT)");

    await db.execute("CREATE TABLE categories ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT)");
    await db.execute(
        "INSERT INTO categories ('id', 'name') values (?, ?)", [1, "Food"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [2, "Education", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [3, "Education 3", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [4, "Education 4", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [5, "Education 5", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [6, "Education 6", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [7, "Education 7", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [8, "Education 8", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [9, "Education 9", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [10, "Education 10", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [11, "Education 11", "Icons.face"]);
    await db.execute("INSERT INTO categories ('id', 'name') values (?, ?)",
        [12, "Education 12", "Icons.face"]);
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

  Future<List<MoneyTransaction>> getTransactions(String date) async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NOTE]);
    var result = await dbClient.rawQuery(
        "SELECT transactions.id, transactions.amount, transactions.description, transactions.transaction_type, transactions.transaction_date, transactions.category_id , categories.name FROM transactions INNER JOIN categories ON transactions.category_id=categories.id WHERE transactions.transaction_date = '$date'");
    if (result.length == 0) return null;
    List<MoneyTransaction> list = result.map((row) {
      return MoneyTransaction.fromMap(row);
    }).toList();
    return list;
  }

  Future<List<MoneyTransaction>> getMonthlyDateTransactions() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NOTE]);
    var result = await dbClient.rawQuery(
        "SELECT transactions.transaction_date FROM transactions GROUP  BY DATE(transactions.transaction_date) ");
    if (result.length == 0) return null;
    List<MoneyTransaction> list = result.map((row) {
      return MoneyTransaction.fromMap(row);
    }).toList();
    return list;
  }

  Future<List<Category>> getCategories() async {
    var dbClient = await db;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NOTE]);
    var result = await dbClient.rawQuery("SELECT * FROM categories");
    if (result.length == 0) return null;
    List<Category> list = result.map((row) {
      return Category.fromMap(row);
    }).toList();
    return list;
  }

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
