import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  ////////////create////////////////////////////////////////

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath,
        'my_database.db'); //my_database.db.  in this we store database
    return openDatabase(path,
        version: 1,
        onCreate:
            _createDatabase); //For initialize database we add a new method where
    // we get the file path. and store our database in our
    // file storage system.
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER
    ) 
    ''');
  }

  //////////////////////////////insert////////////////////////////////////

  static Future<int> insertUser(String name, int age) async {
    final db = await _openDatabase(); //reference to the data base
    final data = {
      // object to be inserted into the database
      'name': name,
      'age': age,
    };
    return await db.insert('users', data);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> getData() async {
    //to display the data
    final db = await _openDatabase();

    return await db.query('users');
  }

  static Future<int> deleteData(int id) async {
    final db = await _openDatabase();
    return await db.delete(
        'users', //where and whereArgs which prevents SQL injection attacks.
        where: 'id = ?',
        whereArgs: [id]); //db.dlt method to dlt
  }

  static Future<Map<String, dynamic>?> getSingleData(int id) async {
    //this functions return single record
    final db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateData(int id, Map<String, dynamic> data) async {
    //this is the update function
    final db = await _openDatabase();
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }
}
