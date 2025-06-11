import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseConnection {
  // Called only once when the DB is first created
  Future<void> _createDatabase(Database database, int version) async {
    await database.execute(
      'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, time TEXT)',
    );
  }

  // Set up or open the database
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'notes_db.db');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    return database;
  }

  // Insert new note
  Future<void> insertData(String title, String content, String time) async {
    var database = await setDatabase();
    await database.insert(
      'notes',
      dataModel(null, title, content, time).dataMap(),
    );
  }

  // Delete a note by ID
  Future<void> deleteData(int id) async {
    var database = await setDatabase();
    await database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  //update
  Future<void> updateData(
    int id,
    String title,
    String content,
    String time,
  ) async {
    var database = await setDatabase();
    await database.update(
      'notes',
      dataModel(id, title, content, time).dataMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Read all notes
  Future<List<Map<String, dynamic>>> readAll() async {
    var database = await setDatabase();
    return await database.query('notes');
  }
}
