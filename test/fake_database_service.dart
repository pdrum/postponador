import 'package:postponador/models/note.dart';
import 'package:postponador/services/database_service.dart';

/**
 * A fake implementation of [DatabaseService] for testing purposes.
 */
class FakeDatabaseService extends DatabaseService {
  final List<Note> fakeNotes = [];

  @override
  Future<List<Note>> getNotes() async {
    return fakeNotes;
  }

  @override
  Future<void> insertNote(Note note) async {
    fakeNotes.add(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    int index = fakeNotes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      fakeNotes[index] = note;
    }
  }
}
