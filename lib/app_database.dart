import 'dart:io';

import 'package:fetch_get/model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();

  Database? _dataBase;

  static const Note_table = 'note_table';
  static const Column_id = 'note_id';
  static const Column_Title = 'note_title';
  static const Column_Desc = 'note_desc';

  Future<Database> getDb() async {
    if (_dataBase != null) {
      return _dataBase!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();

    var dbPath = join(directory.path, "noteDB.db");
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          "Create table $Note_table ( $Column_id integer primary key autoincrement, $Column_Title text, $Column_Desc text ) ");
    });
  }

  Future<void> addNotes(Notes_Model newNotes) async {
    var db = await getDb();
    await db.insert(Note_table, newNotes.toMap());
  }

  fetchAllData() async {
    var db = await getDb();
    List<Map<String, dynamic>> notes = await db.query(Note_table);
    List<Notes_Model> ListNotes = [];
    for (Map<String, dynamic> note in notes) {
      Notes_Model model = Notes_Model.fromMap(note);
      ListNotes.add(model);
    }
    return ListNotes;
  }

  Future<void> updateNotes(Notes_Model notes_model) async{
    var db = await getDb();
    await db.update(Note_table, notes_model.toMap(),
    where: "$Column_id = ${notes_model.id}"
    );

  }
  
  Future<void> deleteNotes(int id)async{
    var db = await getDb();

    await db.delete(Note_table, where: "$Column_id = $id");
    
  }
}
