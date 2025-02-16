/**
 * Represents a note/todo item in the Postponador app.
 *
 * @property id The unique identifier for the note.
 * @property title The title of the note.
 * @property content The content of the note.
 * @property createdAt The timestamp when the note was created.
 * @property isDone Whether the note has been marked as done.
 */
class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isDone;

  /**
   * Constructs a new [Note] instance.
   *
   * @param id the unique identifier for the note.
   * @param title the title of the note.
   * @param content the content of the note.
   * @param createdAt the timestamp when the note was created.
   * @param isDone indicates if the note is marked as done.
   */
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isDone = false,
  });

  /**
   * Converts a map from the database into a [Note] instance.
   *
   * @param map The map representing a note.
   * @return a new [Note] instance.
   */
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      isDone: map['isDone'] == 1, // 1 means true, 0 false
    );
  }

  /**
   * Converts a [Note] instance into a map for database insertion.
   *
   * @return a map representation of the note.
   */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone ? 1 : 0,
    };
  }

  /**
   * Creates a copy of this note with optional changes.
   *
   * @param isDone Optional new done state.
   * @return a new [Note] instance with the updated values.
   */
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
