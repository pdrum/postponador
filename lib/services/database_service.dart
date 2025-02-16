import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

/**
 * A service class for handling local database operations.
 *
 * This class uses the sqflite package to manage a SQLite database.
 */
class DatabaseService {
  Database? _database;

  /**
   * Retrieves the singleton instance of the database.
   *
   * @return a [Database] instance.
   */
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /**
   * Initializes the SQLite database.
   *
   * @return the newly created [Database] instance.
   */
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'postponador.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Updated table schema with isDone column.
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt TEXT,
            isDone INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  /**
   * Retrieves all notes from the database.
   *
   * @return a list of [Note] objects retrieved from the database.
   */
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  /**
   * Inserts a new note into the database.
   *
   * @param note the [Note] object to be inserted.
   */
  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      'notes',
      {
        'title': note.title,
        'content': note.content,
        'createdAt': note.createdAt.toIso8601String(),
        'isDone': note.isDone ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /**
   * Updates an existing note in the database.
   *
   * @param note the [Note] object with updated information.
   */
  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
