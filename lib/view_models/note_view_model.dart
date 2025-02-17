import '../models/note.dart';
import '../services/database_service.dart';

/**
 * The ViewModel responsible for managing notes within the Postponador app.
 *
 * Handles business logic and data manipulation for the notes.
 */
class NoteViewModel {
  final DatabaseService _databaseService;

  List<Note> _notes = [];

  /**
   * Constructs a new [NoteViewModel] instance.
   *
   * @param databaseService The service handling database operations.
   * If not provided, a default instance is used.
   */
  NoteViewModel({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /**
   * Retrieves the current list of notes.
   *
   * @return a list of [Note] objects.
   */
  List<Note> get notes => _notes;

  /**
   * Loads all notes from the local database.
   */
  Future<void> loadNotes() async {
    _notes = await _databaseService.getNotes();
  }

  /**
   * Adds a new note to both the local list and the database.
   *
   * @param note the [Note] object to add.
   */
  Future<void> addNote(Note note) async {
    await _databaseService.insertNote(note);
    _notes.add(note);
  }

  /**
   * Updates a note (e.g., toggling its done state) in both the local list and the database.
   *
   * @param note the updated [Note] object.
   */
  Future<void> updateNote(Note note) async {
    await _databaseService.updateNote(note);
    int index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    }
  }

  /**
   * Toggles the done state of a note.
   *
   * @param note the [Note] object to toggle.
   */
  Future<void> toggleNoteDone(Note note) async {
    final updatedNote = note.copyWith(isDone: !note.isDone);
    await updateNote(updatedNote);
  }
}
