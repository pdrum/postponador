import 'package:flutter_test/flutter_test.dart';
import 'package:postponador/models/note.dart';
import 'package:postponador/view_models/note_view_model.dart';
import '../../test/fake_database_service.dart';

void main() {
  group('NoteViewModel', () {
    late FakeDatabaseService fakeDatabaseService;
    late NoteViewModel noteViewModel;

    setUp(() {
      fakeDatabaseService = FakeDatabaseService();
      noteViewModel = NoteViewModel(databaseService: fakeDatabaseService);
    });

    test('Adding a note updates the list', () async {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'Content',
        createdAt: DateTime.now(),
      );
      await noteViewModel.addNote(note);
      expect(noteViewModel.notes.length, 1);
      expect(noteViewModel.notes.first.content, 'Content');
    });

    test('loadNotes loads data from the database', () async {
      final note = Note(
        id: 2,
        title: 'Another Note',
        content: 'More content',
        createdAt: DateTime.now(),
      );
      await fakeDatabaseService.insertNote(note);
      await noteViewModel.loadNotes();
      expect(noteViewModel.notes.length, 1);
      expect(noteViewModel.notes.first.title, 'Another Note');
    });

    test('toggleNoteDone toggles the done state', () async {
      final note = Note(
        id: 3,
        title: 'Toggle Note',
        content: 'Toggle content',
        createdAt: DateTime.now(),
        isDone: false,
      );
      await fakeDatabaseService.insertNote(note);
      await noteViewModel.loadNotes();
      final original = noteViewModel.notes.first;
      await noteViewModel.toggleNoteDone(original);
      await noteViewModel.loadNotes();
      expect(noteViewModel.notes.first.isDone, true);
    });
  });
}
