import 'package:flutter_test/flutter_test.dart';
import 'package:postponador/models/note.dart';

void main() {
  group('Note Model', () {
    test('toMap and fromMap work correctly including isDone', () {
      final note = Note(
        id: 1,
        title: 'Test Note',
        content: 'This is a test note',
        createdAt: DateTime.parse('2025-02-16T00:00:00'),
        isDone: true,
      );
      final map = note.toMap();
      expect(map['id'], note.id);
      expect(map['title'], note.title);
      expect(map['content'], note.content);
      expect(map['createdAt'], note.createdAt.toIso8601String());
      expect(map['isDone'], 1);

      final noteFromMap = Note.fromMap(map);
      expect(noteFromMap.id, note.id);
      expect(noteFromMap.title, note.title);
      expect(noteFromMap.content, note.content);
      expect(noteFromMap.createdAt, note.createdAt);
      expect(noteFromMap.isDone, true);
    });
  });
}
