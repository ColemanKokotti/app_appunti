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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: NotesFormatter.formatNotes(context, notesContent,subject),
    );
  }
}
