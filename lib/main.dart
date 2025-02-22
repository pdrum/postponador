import 'package:flutter/material.dart';
import 'view_models/note_view_model.dart';
import 'views/calendar_note_screen.dart';

/**
 * The main entry point of the Postponador app.
 */
void main() {
  runApp(const PostponadorApp());
}

/**
 * The root widget of the Postponador app.
 */
class PostponadorApp extends StatelessWidget {
  const PostponadorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteViewModel = NoteViewModel();
    return MaterialApp(
      title: 'Postponador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'PatrickHand',
        ),
      ),
      home: CalendarNoteScreen(noteViewModel: noteViewModel),
    );
  }
}
