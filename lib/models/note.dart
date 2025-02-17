/**
 * Represents a note/todo item in the Postponador app.
 *
 * @property id The unique identifier for the note.
 * @property title The title of the note.
 * @property content The content of the note.
 * @property createdAt The date when the note was created (time set to midnight).
 * @property isDone Whether the note is marked as done.
 */
class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isDone;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isDone = false,
  });

  /// Creates a Note from a Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      isDone: map['isDone'] == 1,
    );
  }

  /// Converts a Note to a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone ? 1 : 0,
    };
  }

  /// Returns a copy of this Note with updated values.
  Note copyWith({bool? isDone}) {
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}
