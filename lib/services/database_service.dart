import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

/**
 * Handles local SQLite database operations.
 */
class DatabaseService {
  Database? _database;

  /// Returns the existing database or initializes it.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database.
  Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'postponador.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
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

  /// Retrieves all notes.
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  /// Inserts a new note.
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

  /// Updates an existing note.
  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// Deletes a note by its id.
  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
