import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postponador/view_models/note_view_model.dart';
import 'package:postponador/views/chat_note_screen.dart';
import '../fake_database_service.dart';

void main() {
  testWidgets('ChatNoteScreen displays date and allows adding and toggling a note',
          (WidgetTester tester) async {
        // Create a fake view model with the fake database.
        final fakeDatabaseService = FakeDatabaseService();
        final noteViewModel = NoteViewModel(databaseService: fakeDatabaseService);

        // Build our app and trigger a frame.
        await tester.pumpWidget(MaterialApp(
          home: ChatNoteScreen(noteViewModel: noteViewModel),
        ));

        // Verify that a date is displayed.
        expect(find.textContaining(RegExp(r'\d{2}-\w{3}-\d{4}')), findsOneWidget);

        // Enter text into the TextField.
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        await tester.enterText(textField, 'Test note for toggle');

        // Tap the send button.
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        // Verify that the note is displayed.
        expect(find.text('Test note for toggle'), findsOneWidget);

        // Initially, the note should show a bullet point (not done).
        expect(find.byIcon(Icons.fiber_manual_record), findsWidgets);

        // Tap the note to toggle its done state.
        await tester.tap(find.text('Test note for toggle'));
        await tester.pumpAndSettle();

        // Verify that the checkmark appears (done state).
        expect(find.byIcon(Icons.check_circle), findsWidgets);
      });
}
