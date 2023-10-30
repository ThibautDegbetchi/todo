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
    const  idType='Interger primary key autoincrement';
    const  todoTextType='text not null';
    const  isDoneType='Boolean not null';
    await db.execute('''
    CREATE TABLE $tableNotes(
    ${TodoFields.id} $idType,
    ${TodoFields.todoText} $todoTextType,
    ${TodoFields.isDone} $isDoneType
     )
    ''');
  }
    Future<ToDo> create(ToDo note) async{
    final db =await instance.database;
    final id=await db?.insert(tableNotes, note.toJson());
    return note.copy(id:id);
    }
  Future<ToDo> readToOo(int id)async{
    final db= await instance.database;
    final maps=await db?.query(
      tableNotes,
      columns: TodoFields.values,
      where: '${TodoFields.id}= ?',
      whereArgs:[id],
    );
    if(maps!.isNotEmpty){
      return ToDo.fromJson(maps.first);
    }else{
      throw Exception('Id $id not found');
    }
  }
  Future<List<ToDo>?> readAllNote()async{
    final db=await instance.database;
    const  orderby='${TodoFields.id} asc';
    final result=await db?.query(tableNotes,orderBy: orderby);
    return result?.map((json) => ToDo.fromJson(json)).toList();
  }

  Future<int> update(ToDo todo)async{
    final db=await instance.database;
    return db!.update(tableNotes,
        todo.toJson(),
        where: '${TodoFields.id}=?',
    whereArgs: [todo.id]);
  }
  Future<int> delete(int id)async{
    final db=await instance.database;
    return await db!.delete(
      tableNotes,
      whereArgs:[id],
      where: '${TodoFields.id}=?'
    );
  }

  Future close()async{
    final db=await instance.database;
    db?.close();
  }
}
