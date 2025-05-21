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
    List<Widget> paragraphWidgets = []; // Per contenere sia testo che blocchi di codice nel paragrafo

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

      // Identifica i paragrafi con numeri romani
      if (BaseFormatter.isNewParagraphStart(trimmedLine)) {
        // Se era già in un paragrafo, salva il contenuto precedente
        if (isInParagraph) {
          if (paragraphContent.isNotEmpty) {
            // Aggiunge i testi normali come RichText
            paragraphWidgets.add(
                ParagraphFormatter.buildParagraphTextContent(context, paragraphContent)
            );
            paragraphContent = [];
          }

          // Crea un widget di paragrafo completo con tutti i contenuti raccolti
          if (paragraphWidgets.isNotEmpty) {
            widgets.add(ParagraphFormatter.buildCompleteParagraph(context, currentParagraph, paragraphWidgets));
            paragraphWidgets = [];
          }
        }

        // Nuovo paragrafo
        currentParagraph = trimmedLine;
        isInParagraph = true;
      }
      // Rileva inizio o fine di un blocco di codice
      else if (BaseFormatter.isCodeBlockStart(trimmedLine)) {
        // Se stiamo entrando in un blocco di codice
        if (!CodeBlockFormatter.isInCodeBlock) {
          // Se c'è testo accumulato nel paragrafo, lo salviamo prima
          if (paragraphContent.isNotEmpty) {
            paragraphWidgets.add(
                ParagraphFormatter.buildParagraphTextContent(context, paragraphContent)
            );
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
          // Aggiungiamo il blocco di codice ai widget del paragrafo
          if (isInParagraph) {
            paragraphWidgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          } else {
            // Se non siamo in un paragrafo, aggiungiamo un blocco di codice standalone
            widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          }
          CodeBlockFormatter.isInCodeBlock = false;
        }
        // Altrimenti aggiungiamo la riga al buffer del codice
        else {
          CodeBlockFormatter.appendLine(line);
        }
      }
      // Se siamo in un blocco di codice, aggiungiamo la riga al buffer
      else if (CodeBlockFormatter.isInCodeBlock) {
        CodeBlockFormatter.appendLine(line);

        // Se dovremmo chiudere il blocco di codice
        if (CodeBlockFormatter.shouldCloseBlock(lines, i)) {
          if (isInParagraph) {
            paragraphWidgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          } else {
            widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
          }
          CodeBlockFormatter.isInCodeBlock = false;
        }
      }
      // Contenuto del paragrafo normale
      else if (isInParagraph && trimmedLine.isNotEmpty) {
        paragraphContent.add(line);
      }
      // Testo normale non associato a un paragrafo
      else if (trimmedLine.isNotEmpty) {
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
    if (isInParagraph) {
      if (paragraphContent.isNotEmpty) {
        paragraphWidgets.add(
            ParagraphFormatter.buildParagraphTextContent(context, paragraphContent)
        );
      }

      if (paragraphWidgets.isNotEmpty) {
        widgets.add(ParagraphFormatter.buildCompleteParagraph(context, currentParagraph, paragraphWidgets));
      }
    }

    // Aggiungi l'ultimo blocco di codice se esiste
    if (CodeBlockFormatter.isInCodeBlock) {
      if (isInParagraph) {
        paragraphWidgets.add(CodeBlockFormatter.buildCodeBlockWidget());
        widgets.add(ParagraphFormatter.buildCompleteParagraph(context, currentParagraph, paragraphWidgets));
      } else {
        widgets.add(CodeBlockFormatter.buildCodeBlockWidget());
      }
    }

    return widgets;
  }
}