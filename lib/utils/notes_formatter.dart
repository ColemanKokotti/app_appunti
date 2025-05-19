import 'package:appunti/utils/text_content_formatter.dart';
import 'package:appunti/widgets/notes/code_block_widget.dart';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class NotesFormatter {
  static List<Widget> formatNotes(BuildContext context, String content) {
    final List<Widget> widgets = [];
    final List<String> lines = content.split('\n');

    String mainTitle = '';
    bool isInParagraph = false;
    String currentParagraph = '';
    List<String> paragraphContent = [];

    // Variabili per gestire i blocchi di codice
    bool isInCodeBlock = false;
    StringBuffer codeBuffer = StringBuffer();

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final String trimmedLine = line.trim();

      // Identifica il titolo principale (prima riga non vuota)
      if (mainTitle.isEmpty && trimmedLine.isNotEmpty) {
        mainTitle = trimmedLine;
        widgets.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(0, 2),
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

      // Rileva inizio o fine di un blocco di codice
      if (trimmedLine.startsWith('```') ||
          trimmedLine == 'C#' ||
          trimmedLine.startsWith('int[') ||
          trimmedLine.startsWith('int ') ||
          trimmedLine.startsWith('double ') ||
          trimmedLine.startsWith('string ') ||
          trimmedLine.startsWith('bool ') ||
          trimmedLine.startsWith('List<') ||
          trimmedLine.startsWith('Stack<') ||
          trimmedLine.startsWith('Queue<') ||
          trimmedLine.startsWith('Dictionary<') ||
          trimmedLine.startsWith('HashSet<') ||
          trimmedLine.startsWith('class ') ||
          trimmedLine.startsWith('interface ') ||
          trimmedLine.startsWith('abstract class ') ||
          trimmedLine.startsWith('void ') ||
          trimmedLine.startsWith('static ') ||
          trimmedLine.startsWith('public ') ||
          trimmedLine.startsWith('private ') ||
          trimmedLine.startsWith('protected ') ||
          trimmedLine.startsWith('for (') ||
          trimmedLine.startsWith('while (') ||
          trimmedLine.startsWith('switch (') ||
          trimmedLine.startsWith('if (') ||
          trimmedLine.startsWith('else ') ||
          trimmedLine.contains(' => ') ||
          trimmedLine == 'do' ||
          (trimmedLine.startsWith('using ') && trimmedLine.contains('('))) {

        // Se stiamo entrando in un blocco di codice
        if (!isInCodeBlock) {
          // Se eravamo in un paragrafo, salviamo il suo contenuto
          if (isInParagraph && paragraphContent.isNotEmpty) {
            widgets.add(_buildParagraphContent(context, currentParagraph, paragraphContent));
            paragraphContent = [];
          }
          isInCodeBlock = true;
          codeBuffer.clear();

          // Se la riga non è solo un delimitatore, aggiungiamola al buffer
          if (!trimmedLine.startsWith('```') && trimmedLine != 'C#') {
            codeBuffer.writeln(line);
          }
        }
        // Se stavamo già in un blocco di codice e troviamo un delimitatore di fine
        else if (trimmedLine.startsWith('```')) {
          // Aggiungiamo il blocco di codice ai widget
          widgets.add(CodeBlockWidget(code: codeBuffer.toString().trim()));
          isInCodeBlock = false;
        }
        // Altrimenti aggiungiamo la riga al buffer del codice
        else {
          codeBuffer.writeln(line);
        }
        continue;
      }

      // Se siamo in un blocco di codice, aggiungiamo la riga al buffer
      if (isInCodeBlock) {
        codeBuffer.writeln(line);

        // Se la prossima riga è vuota o è un nuovo paragrafo, chiudiamo il blocco di codice
        if (i == lines.length - 1 ||
            (i + 1 < lines.length &&
                (lines[i + 1].trim().isEmpty ||
                    _isNewParagraphStart(lines[i + 1])))) {
          widgets.add(CodeBlockWidget(code: codeBuffer.toString().trim()));
          isInCodeBlock = false;
        }
        continue;
      }

      // Identifica i paragrafi con numeri romani
      if (_isNewParagraphStart(trimmedLine)) {
        // Se era già in un paragrafo, salva il contenuto precedente
        if (isInParagraph) {
          widgets.add(_buildParagraphContent(context, currentParagraph, paragraphContent));
          paragraphContent = [];
        }

        // Nuovo paragrafo
        currentParagraph = trimmedLine;
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
      } else if (isInParagraph && trimmedLine.isNotEmpty) {
        // Contenuto del paragrafo
        paragraphContent.add(line);
      } else if (trimmedLine.isNotEmpty) {
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
      widgets.add(_buildParagraphContent(context, currentParagraph, paragraphContent));
    }

    // Aggiungi l'ultimo blocco di codice se esiste
    if (isInCodeBlock && codeBuffer.isNotEmpty) {
      widgets.add(CodeBlockWidget(code: codeBuffer.toString().trim()));
    }

    return widgets;
  }

  static bool _isNewParagraphStart(String line) {
    return line.startsWith('I.') || line.startsWith('II.') ||
        line.startsWith('III.') || line.startsWith('IV.') ||
        line.startsWith('V.') || line.startsWith('VI.') ||
        line.startsWith('VII.') || line.startsWith('VIII.') ||
        line.startsWith('IX.') || line.startsWith('X.') ||
        line.startsWith('XI.') || line.startsWith('XII.');
  }

  static Widget _buildParagraphContent(BuildContext context, String title, List<String> content) {
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
              child: TextContentFormatter.buildRichText(line, isDefinition),
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
}