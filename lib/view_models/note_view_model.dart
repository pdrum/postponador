import '../models/note.dart';
import '../services/database_service.dart';

/**
 * Manages note data and business logic.
 */
class NoteViewModel {
  final DatabaseService _databaseService;

  List<Note> _notes = [];

  NoteViewModel({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Returns the list of notes.
  List<Note> get notes => _notes;

  /// Loads notes from the database.
  Future<void> loadNotes() async {
    _notes = await _databaseService.getNotes();
  }

  /// Adds a new note.
  Future<void> addNote(Note note) async {
    await _databaseService.insertNote(note);
    _notes.add(note);
  }

  /// Updates a note.
  Future<void> updateNote(Note note) async {
    await _databaseService.updateNote(note);
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) _notes[index] = note;
  }

  /// Deletes a note.
  Future<void> deleteNote(Note note) async {
    await _databaseService.deleteNote(note.id);
    _notes.removeWhere((n) => n.id == note.id);
  }

  /// Toggles the done state of a note.
  Future<void> toggleNoteDone(Note note) async {
    final updatedNote = note.copyWith(isDone: !note.isDone);
    await updateNote(updatedNote);
  }
}
