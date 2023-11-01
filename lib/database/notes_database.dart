import 'package:path/path.dart';
import 'package:todolist/model/todo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class NotesDatabase{

  static final NotesDatabase instance=NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async{
    if(_database !=null) return _database!;
    _database = await _initDB('note.db');
    print('-----------------------init Db okay-----------------------------');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    Database db;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dbPath =await getDatabasesPath();
    print(dbPath);
    final path =join(dbPath,filename);
    print(dbPath);
    db=await openDatabase(path,version: 1,);
    print('db is okay');
    _createDB(db,1);
    return  db;
  }
  Future _createDB(Database db,int version) async{
    const  idType='Integer primary key autoincrement not null';
    const  todoTextType='text not null';
    const  isDoneType='Boolean not null';
    print('ready to create table');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNotes(
    ${TodoFields.id} $idType,
    ${TodoFields.todoText} $todoTextType,
    ${TodoFields.isDone} $isDoneType
     )
    ''');
    print('Table notes create succesfully');
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
