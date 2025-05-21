import 'package:appunti/utils/formatters/paragraph_formatter.dart';
import 'package:appunti/utils/formatters/title_formatter.dart';
import 'package:flutter/material.dart';
import 'base_formatter.dart';
import 'code_block_formatter.dart';

class NotesFormatter {
  static List<Widget> formatNotes(BuildContext context, String content, String subjectName) {
    final List<Widget> widgets = [];
    final List<String> lines = content.split('\n');

    String mainTitle = '';
    bool isInParagraph = false;
    String currentParagraph = '';
    List<String> paragraphContent = [];

    // Reset code block formatter state and set subject name
    CodeBlockFormatter.reset();
    CodeBlockFormatter.setSubjectName(subjectName);

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final String trimmedLine = line.trim();

      // Identifica il titolo principale (prima riga non vuota)
      if (mainTitle.isEmpty && trimmedLine.isNotEmpty) {
        mainTitle = trimmedLine;
        widgets.add(TitleFormatter.buildMainTitle(context, mainTitle));
        continue;
      }

      // Rileva inizio o fine di un blocco di codice
      if (BaseFormatter.isCodeBlockStart(trimmedLine)) {
        // Se stiamo entrando in un blocco di codice
        if (!CodeBlockFormatter.isInCodeBlock) {
          // Se eravamo in un paragrafo, salviamo il suo contenuto
          if (isInParagraph && paragraphContent.isNotEmpty) {
            widgets.add(ParagraphFormatter.buildParagraphContent(context, paragraphContent));
            paragraphContent = [];
          }
          CodeBlockFormatter.isInCodeBlock = true;

          // Se la riga non è solo un delimitatore, aggiungiamola al buffer
          if (!trimmedLine.startsWith('```') && trimmedLine != 'C#') {
            CodeBlockFormatter.appendLine(line);
          }
        }
        // Se stavamo già in un blocco di codice e troviamo un delimitatore di fine
        else if (trimmedLine.startsWith('```')) {
          // Aggiungiamo il blocco di codice ai widget
          widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          CodeBlockFormatter.isInCodeBlock = false;
        }
        // Altrimenti aggiungiamo la riga al buffer del codice
        else {
          CodeBlockFormatter.appendLine(line);
        }
        continue;
      }

      // Se siamo in un blocco di codice, aggiungiamo la riga al buffer
      if (CodeBlockFormatter.isInCodeBlock) {
        CodeBlockFormatter.appendLine(line);

        // Se dovremmo chiudere il blocco di codice
        if (CodeBlockFormatter.shouldCloseBlock(lines, i)) {
          widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          CodeBlockFormatter.isInCodeBlock = false;
        }
        continue;
      }

      // Identifica i paragrafi con numeri romani
      if (BaseFormatter.isNewParagraphStart(trimmedLine)) {
        // Se era già in un paragrafo, salva il contenuto precedente
        if (isInParagraph && paragraphContent.isNotEmpty) {
          widgets.add(ParagraphFormatter.buildParagraphContent(context, paragraphContent));
          paragraphContent = [];
        }

        // Nuovo paragrafo
        currentParagraph = trimmedLine;
        isInParagraph = true;
        widgets.add(ParagraphFormatter.buildParagraphHeader(context, currentParagraph));
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
      widgets.add(ParagraphFormatter.buildParagraphContent(context, paragraphContent));
    }

    // Aggiungi l'ultimo blocco di codice se esiste
    if (CodeBlockFormatter.isInCodeBlock) {
      widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
    }

    return widgets;
  }
}