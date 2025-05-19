import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject.dart';
import '../themes/app_theme.dart';

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

  List<Widget> _formatNotes(String content) {
    final List<Widget> widgets = [];
    final List<String> lines = content.split('\n');

    String mainTitle = '';
    bool isInParagraph = false;
    String currentParagraph = '';
    List<String> paragraphContent = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Identifica il titolo principale (prima riga non vuota)
      if (mainTitle.isEmpty && line.isNotEmpty) {
        mainTitle = line;
        widgets.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              mainTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        continue;
      }

      // Identifica i paragrafi con numeri romani
      if (line.startsWith('I.') || line.startsWith('II.') ||
          line.startsWith('III.') || line.startsWith('IV.') ||
          line.startsWith('V.') || line.startsWith('VI.') ||
          line.startsWith('VII.') || line.startsWith('VIII.') ||
          line.startsWith('IX.') || line.startsWith('X.')) {

        // Se era già in un paragrafo, salva il contenuto precedente
        if (isInParagraph) {
          widgets.add(_buildParagraphContent(currentParagraph, paragraphContent));
          paragraphContent = [];
        }

        // Nuovo paragrafo
        currentParagraph = line;
        isInParagraph = true;
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 1,
              ),
            ),
            child: Text(
              currentParagraph,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.headingColor,
              ),
            ),
          ),
        );
      } else if (isInParagraph && line.isNotEmpty) {
        // Contenuto del paragrafo
        paragraphContent.add(line);
      } else if (line.isNotEmpty) {
        // Testo normale non associato a un paragrafo
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Text(
              line,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }

    // Aggiungi l'ultimo paragrafo se esiste
    if (isInParagraph && paragraphContent.isNotEmpty) {
      widgets.add(_buildParagraphContent(currentParagraph, paragraphContent));
    }

    return widgets;
  }


  Widget _buildParagraphContent(String title, List<String> content) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(left: 8.0, right: 0, bottom: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((line) {
          // Verifica se la linea contiene una definizione (inizia con una parola seguita da :)
          final isDefinition = RegExp(r'^\w+(\s\w+)*:').hasMatch(line);

          // Invece di restituire un semplice Text widget, usiamo un RichText per formattare parti specifiche
          if (line.contains(':') || (line.contains('(') && line.contains(')'))) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: _buildRichText(line, isDefinition),
            );
          } else {
            // Se non ci sono : o parentesi, usiamo il classico Text widget
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: null,
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }

  // Questo metodo costruisce un RichText con stili diversi per parti differenti del testo
  Widget _buildRichText(String line, bool isDefinition) {
    final List<TextSpan> spans = [];

    // Caso di testo con i due punti
    if (line.contains(':')) {
      final parts = line.split(':');

      // Parte prima dei due punti (il sottotitolo)
      spans.add(TextSpan(
        text: parts[0] + ':',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.subheadingColor, // Colore per il sottotitolo
        ),
      ));

      // Parte dopo i due punti (se esiste)
      if (parts.length > 1) {
        spans.add(TextSpan(
          text: parts.sublist(1).join(':'),  // Nel caso ci siano più : nella stringa
          style: const TextStyle(
            fontSize: 16,
            color: null, // Colore normale per il resto del testo
          ),
        ));
      }
    }
    // Gestione del testo con parentesi
    else if (line.contains('(') && line.contains(')')) {
      final buffer = StringBuffer();
      bool inParenthesis = false;

      for (int i = 0; i < line.length; i++) {
        final char = line[i];

        if (char == '(') {
          // Aggiungiamo il testo raccolto finora fuori dalle parentesi
          if (buffer.isNotEmpty) {
            spans.add(TextSpan(
              text: buffer.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ));
            buffer.clear();
          }
          buffer.write(char);
          inParenthesis = true;
        }
        else if (char == ')' && inParenthesis) {
          buffer.write(char);
          // Aggiungiamo il testo tra parentesi con stile diverso
          spans.add(TextSpan(
            text: buffer.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.primaryColor, // Colore primario per il testo tra parentesi
              fontStyle: FontStyle.italic,
            ),
          ));
          buffer.clear();
          inParenthesis = false;
        }
        else {
          buffer.write(char);
        }
      }

      // Se c'è ancora del testo nel buffer, aggiungiamolo
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(
          text: buffer.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appunti di ${widget.subject.name}'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ))
            : Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _formatNotes(_notesContent),
            ),
          ),
        ),
      ),
    );
  }
}