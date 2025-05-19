import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject.dart';


class NotesPage extends StatefulWidget {
  final Subject subject;

  const NotesPage({super.key, required this.subject});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String _notesContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final content = await rootBundle.loadString(widget.subject.assetPath);
      setState(() {
        _notesContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _notesContent = 'Errore nel caricamento degli appunti: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appunti di ${widget.subject.name}'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _notesContent,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}