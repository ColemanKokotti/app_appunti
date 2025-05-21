import 'package:flutter/material.dart';
import '../../utils/formatters/notes_formatter.dart';

class NotesContentViewer extends StatelessWidget {
  final String notesContent;
  final String subject;

  const NotesContentViewer({
    super.key,
    required this.notesContent,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap in a Container with width constraint to ensure children have proper bounds
    return Container(
      width: MediaQuery.of(context).size.width - 20, // Full width minus padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: NotesFormatter.formatNotes(context, notesContent, subject),
      ),
    );
  }
}