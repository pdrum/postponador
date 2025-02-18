import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/note.dart';
import '../../view_models/note_view_model.dart';
import 'components/date_navigation_row.dart';
import 'components/notes_list.dart';
import 'components/input_area.dart';

/// A calendar-like screen for taking notes.
///
/// This screen displays notes for a selected date, including date navigation,
/// an inline "go to today" control, a list of notes, and a text input area.
/// Tapping anywhere outside the input area will dismiss the keyboard.
class CalendarNoteScreen extends StatefulWidget {
  final NoteViewModel noteViewModel;

  /// Constructs a [CalendarNoteScreen] with the given [noteViewModel].
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

  /// Loads and filters notes for the given [date].
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

  /// Opens the date picker and updates the selected date if a new date is chosen.
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
      _loadNotesForDate(_selectedDate);
    }
  }

  /// Adds a new note for the selected date using the input from [_noteController].
  Future<void> _addNewNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    final noteDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final newNote = Note(
      id: 0, // Database will auto-generate the ID.
      title: 'Note',
      content: text,
      createdAt: noteDate,
      isDone: false,
    );
    await widget.noteViewModel.addNote(newNote);
    _noteController.clear();
    _loadNotesForDate(_selectedDate);
  }

  /// Toggles the "done" state of the given [note].
  Future<void> _toggleNote(Note note) async {
    await widget.noteViewModel.toggleNoteDone(note);
    _loadNotesForDate(_selectedDate);
  }

  /// Deletes the given [note].
  Future<void> _deleteNote(Note note) async {
    await widget.noteViewModel.deleteNote(note);
    _loadNotesForDate(_selectedDate);
  }

  /// Resets the selected date to today's date.
  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
    _loadNotesForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    // Format date as "Mon 15 Feb".
    final dateString = DateFormat('EEE d MMM').format(_selectedDate);
    final isToday = _selectedDate ==
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light pastel green.
      appBar: AppBar(
        title: const Text('Postponador'),
        backgroundColor: const Color(0xFFC8E6C9), // Pastel green.
      ),
      // Wrap the body with a GestureDetector to dismiss the keyboard on tap.
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            DateNavigationRow(
              dateString: dateString,
              isToday: isToday,
              onPrevious: _goToPreviousDay,
              onNext: _goToNextDay,
              onPickDate: _pickDate,
              onGoToToday: _goToToday,
            ),
            Expanded(
              child: NotesList(
                notes: _filteredNotes,
                onToggle: _toggleNote,
                onDelete: _deleteNote,
              ),
            ),
            InputArea(
              noteController: _noteController,
              onSubmit: _addNewNote,
            ),
          ],
        ),
      ),
    );
  }
}
