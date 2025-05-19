import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject.dart';
import '../themes/app_theme.dart';
import '../widgets/notes/notes_content_viewer.dart';
import '../widgets/notes/magnifier_overlay.dart';

class NotesPage extends StatefulWidget {
  final Subject subject;

  const NotesPage({super.key, required this.subject});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String _notesContent = '';
  bool _isLoading = true;
  bool _showMagnifier = false;
  final ValueNotifier<Offset> _magnifierPosition = ValueNotifier<Offset>(Offset.zero);
  final ValueNotifier<double> _zoomLevel = ValueNotifier<double>(1.5);

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _magnifierPosition.dispose();
    _zoomLevel.dispose();
    super.dispose();
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

  void _toggleMagnifier() {
    setState(() {
      _showMagnifier = !_showMagnifier;
    });
  }

  void _updateMagnifierPosition(Offset position) {
    _magnifierPosition.value = position;
  }

  void _adjustZoomLevel(double change) {
    _zoomLevel.value = (_zoomLevel.value + change).clamp(1.2, 3.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appunti di ${widget.subject.name}'),
        elevation: 0,
      /*  actions: [
          IconButton(
            icon: Icon(_showMagnifier ? Icons.zoom_out : Icons.zoom_in),
            onPressed: _toggleMagnifier,
            tooltip: _showMagnifier ? 'Disattiva lente' : 'Attiva lente d\'ingrandimento',
          ),
          if (_showMagnifier)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _adjustZoomLevel(0.1),
              tooltip: 'Aumenta zoom',
            ),
          if (_showMagnifier)
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => _adjustZoomLevel(-0.1),
              tooltip: 'Diminuisci zoom',
            ),
        ],*/
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ))
            : Stack(
          children: [
            GestureDetector(
              onPanUpdate: _showMagnifier ? (details) => _updateMagnifierPosition(details.globalPosition) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: NotesContentViewer(
                    notesContent: _notesContent,
                    subject: widget.subject.name,
                  ),
                ),
              ),
            ),
            if (_showMagnifier)
              MagnifierOverlay(
                position: _magnifierPosition,
                zoomLevel: _zoomLevel,
              ),
          ],
        ),
      ),
    );
  }
}