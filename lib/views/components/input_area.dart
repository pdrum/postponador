import 'package:flutter/material.dart';

/// A widget that provides a text input area with a send button.
///
/// This component is used to add new notes for the selected date. When the
/// send button is pressed, the keyboard will collapse.
class InputArea extends StatelessWidget {
  final TextEditingController noteController;
  final VoidCallback onSubmit;

  /// Constructs an [InputArea] widget.
  const InputArea({
    Key? key,
    required this.noteController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: noteController,
              decoration: const InputDecoration(
                hintText: "What's on your mind lately?",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black54),
            onPressed: () {
              // Collapse the keyboard
              FocusScope.of(context).unfocus();
              // Then submit the note
              onSubmit();
            },
          ),
        ],
      ),
    );
  }
}
