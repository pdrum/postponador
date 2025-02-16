import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../view_models/note_view_model.dart';

/**
 * A stateful widget representing a chatbot-like interface for taking notes.
 * Users can navigate between dates and view/add notes for the selected date.
 */
class ChatNoteScreen extends StatefulWidget {
  final NoteViewModel noteViewModel;

  /**
   * Constructs a new [ChatNoteScreen] instance.
   *
   * @param noteViewModel The view model that manages the app's note data.
   */
  const ChatNoteScreen({Key? key, required this.noteViewModel}) : super(key: key);

  @override
  _ChatNoteScreenState createState() => _ChatNoteScreenState();
}

/**
 * The state class for [ChatNoteScreen].
 *
 * It holds the current selected date, retrieves notes for that date,
 * and handles the logic for adding new notes and toggling note states.
 */
class _ChatNoteScreenState extends State<ChatNoteScreen> {
  /// The currently selected date for which notes are displayed.
  late DateTime _selectedDate;

  /// A list of notes filtered by [_selectedDate].
  List<Note> _filteredNotes = [];

  /// A controller for the text field where the user types a new note.
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadNotesForDate(_selectedDate);
  }

  /**
   * Loads the notes from the ViewModel for a specific date.
   *
   * @param date The date for which to load notes.
   */
  Future<void> _loadNotesForDate(DateTime date) async {
    await widget.noteViewModel.loadNotes();
    setState(() {
      _filteredNotes = widget.noteViewModel.notes
          .where((note) => _isSameDate(note.createdAt, date))
          .toList();
    });
  }

  /**
   * Checks if two DateTime objects fall on the same calendar day.
   *
   * @param date1 The first date to compare.
   * @param date2 The second date to compare.
   * @return true if both dates are on the same day, otherwise false.
   */
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /**
   * Moves the selected date one day backward.
   */
  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _loadNotesForDate(_selectedDate);
  }

  /**
   * Moves the selected date one day forward.
   */
  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _loadNotesForDate(_selectedDate);
  }

  /**
   * Adds a new note to the current date using the text from [_noteController].
   * Clears the text field and refreshes the list of notes for the date.
   */
  Future<void> _addNewNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final newNote = Note(
      // id is not used here because the database auto-increments it.
      id: 0,
      title: 'Note',
      content: text,
      createdAt: DateTime.now(),
      isDone: false,
    );
    await widget.noteViewModel.addNote(newNote);

    _noteController.clear();
    _loadNotesForDate(_selectedDate);
  }

  /**
   * Toggles the done state of a note when it is tapped.
   *
   * @param note The [Note] object to toggle.
   */
  Future<void> _toggleNote(Note note) async {
    await widget.noteViewModel.toggleNoteDone(note);
    _loadNotesForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('dd-MMM-yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Very light pastel background.
      appBar: AppBar(
        title: const Text('Postponador'),
        backgroundColor: const Color(0xFFAEDFF7), // Pastel blue.
      ),
      body: Column(
        children: [
          // Date navigation row.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, size: 32),
                  onPressed: _goToPreviousDay,
                ),
                Text(
                  dateString,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return GestureDetector(
                  onTap: () => _toggleNote(note),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5), // Pastel pink.
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFFB0C4DE), // Light pastel blue-gray.
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /**
                         * Displays a checkmark if done; otherwise a bullet point.
                         */
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            note.isDone
                                ? Icons.check_circle
                                : Icons.fiber_manual_record,
                            color: note.isDone ? Colors.green : Colors.black54,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('HH:mm').format(note.createdAt),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field for a new note.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF0), // Pastel greenish background.
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Type your note...',
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
