import 'package:flutter/material.dart';
import '../../models/note.dart';

/// A widget that displays a list of notes.
///
/// Each note is shown in a container with a delete icon, and tapping a note
/// toggles its "done" state.
class NotesList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onToggle;
  final Function(Note) onDelete;

  /// Constructs a [NotesList] widget.
  const NotesList({
    Key? key,
    required this.notes,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () => onToggle(note),
          child: Container(
            key: Key('note_${note.id}'),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFBBDEFB), // Pastel blue.
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: const Color(0xFF64B5F6),
                width: 2.0,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    note.isDone ? Icons.check_circle : Icons.fiber_manual_record,
                    color: note.isDone ? Colors.green : Colors.black54,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    note.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFEF9A9A), size: 20),
                  onPressed: () => onDelete(note),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
