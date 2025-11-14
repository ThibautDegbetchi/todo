import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/model/user.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filename) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);

    return await openDatabase(
      path,
      version: 1, // On commence avec la version 1
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE $tableUsers (
      ${UserFields.id} $idType,
      ${UserFields.username} $textType UNIQUE,
      ${UserFields.password} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableNotes (
      ${TodoFields.id} $idType,
      ${TodoFields.todoText} $textType,
      ${TodoFields.isDone} $boolType
    )
    ''');
  }

  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db.insert(tableUsers, user.toJson());
    return user;
  }

  Future<User?> readUser(String username) async {
    final db = await instance.database;
    final maps = await db.query(
      tableUsers,
      columns: UserFields.values,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // --- MÉTHODES POUR LES TÂCHES (ToDo) ---

  Future<ToDo> create(ToDo note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<ToDo> readToOo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ToDo.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<List<ToDo>> readAllNote() async {
    final db = await instance.database;
    const orderby = '${TodoFields.id} ASC';
    final result = await db.query(tableNotes, orderBy: orderby);
    return result.map((json) => ToDo.fromJson(json)).toList();
  }

  Future<int> update(ToDo todo) async {
    final db = await instance.database;
    return db.update(tableNotes, todo.toJson(),
        where: '${TodoFields.id} = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableNotes, where: '${TodoFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}