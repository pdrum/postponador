import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../view_models/note_view_model.dart';

/**
 * A calendar-like screen for taking notes.
 *
 * Displays notes for the selected date with inline navigation. A "go to today"
 * control appears next to the date when the displayed date isn’t today.
 */
class CalendarNoteScreen extends StatefulWidget {
  final NoteViewModel noteViewModel;

  const CalendarNoteScreen({Key? key, required this.noteViewModel}) : super(key: key);

  @override
  _CalendarNoteScreenState createState() => _CalendarNoteScreenState();
}

class _CalendarNoteScreenState extends State<CalendarNoteScreen> {
  late DateTime _selectedDate;
  List<Note> _filteredNotes = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Set _selectedDate to today at midnight.
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadNotesForDate(_selectedDate);
  }

  /// Loads notes for the given date.
  Future<void> _loadNotesForDate(DateTime date) async {
    await widget.noteViewModel.loadNotes();
    setState(() {
      _filteredNotes = widget.noteViewModel.notes.where((note) {
        return note.createdAt.year == date.year &&
            note.createdAt.month == date.month &&
            note.createdAt.day == date.day;
      }).toList();
    });
  }

  /// Moves the selected date one day backward.
  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _loadNotesForDate(_selectedDate);
  }

  /// Moves the selected date one day forward.
  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _loadNotesForDate(_selectedDate);
  }

  /// Adds a new note for the selected date.
  Future<void> _addNewNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    // Use the selected date (with time set to midnight)
    final noteDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final newNote = Note(
      id: 0, // Database auto-generates ID.
      title: 'Note',
      content: text,
      createdAt: noteDate,
      isDone: false,
    );
    await widget.noteViewModel.addNote(newNote);
    _noteController.clear();
    _loadNotesForDate(_selectedDate);
  }

  /// Toggles the done state of a note.
  Future<void> _toggleNote(Note note) async {
    await widget.noteViewModel.toggleNoteDone(note);
    _loadNotesForDate(_selectedDate);
  }

  /// Deletes a note.
  Future<void> _deleteNote(Note note) async {
    await widget.noteViewModel.deleteNote(note);
    _loadNotesForDate(_selectedDate);
  }

  /// Resets the view to today.
  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
    _loadNotesForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    // Updated date format: "Mon 15 Feb"
    final dateString = DateFormat('EEE d MMM').format(_selectedDate);
    final isToday = _selectedDate ==
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light pastel green.
      appBar: AppBar(
        title: const Text('Postponador'),
        backgroundColor: const Color(0xFFC8E6C9), // Pastel green.
      ),
      body: Column(
        children: [
          // Date navigation row with inline "go to today" control.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 32),
                  onPressed: _goToPreviousDay,
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateString,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // Inline "go to today" icon and text appear only if not today.
                        if (!isToday)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextButton.icon(
                              onPressed: _goToToday,
                              icon: const Icon(Icons.flash_on, size: 16, color: Colors.black54),
                              label: const Text(
                                "Today",
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right, size: 32),
                  onPressed: _goToNextDay,
                ),
              ],
            ),
          ),
          // List of notes.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return GestureDetector(
                  onTap: () => _toggleNote(note),
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
                        // Display checkmark if done; otherwise, a bullet.
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            note.isDone ? Icons.check_circle : Icons.fiber_manual_record,
                            color: note.isDone ? Colors.green : Colors.black54,
                            size: 20,
                          ),
                        ),
                        // Note text.
                        Expanded(
                          child: Text(
                            note.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        // Delete icon in softer pastel red.
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFEF9A9A), size: 20),
                          onPressed: () => _deleteNote(note),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field for new note.
          Container(
            margin: const EdgeInsets.only(
                left: 12.0, right: 12.0, bottom: 40.0, top: 12.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFC8E6C9), // Pastel green.
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your note for this date...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black54),
                  onPressed: _addNewNote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
