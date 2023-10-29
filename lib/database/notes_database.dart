import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/todo.dart';

class NotesDatabase{
  static final NotesDatabase instance=NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database?> get database async{
    if(_database !=null) return _database;
    _database =await _iniDB('note.db');
    return _database;
  }

  Future<Database> _iniDB(String filePath) async {
    final dbPath =await getDatabasesPath();
    final path =join(dbPath,filePath);
    return  await openDatabase(path,version: 1,onCreate: _createDB);

  }
  Future _createDB(Database db,int version) async{
    final idType='Interger primary key autoincrement';
    final todoTextType='text not null';
    final isDoneType='Boolean not null';
    await db.execute('''
    CREATE TABLE $tableNotes(
    ${NoteFields.id} ${idType},
    ${NoteFields.todoText} ${todoTextType},
    ${NoteFields.isDone} ${isDoneType}
     )
    ''');
  }
    Future<ToDo> create(ToDo note) async{
    final db =await instance.database;
    final id=await db?.insert(tableNotes, note.toJson());
    return note.copy(id:id);
    }
  Future<ToDo> readToOo(int id)async{
    final maps=await db.query(
      tableNotes,
      colums: NoteFields.value,
    )
  }
  Future close()async{
    final db=await instance.database;
    db?.close();
  }
}
