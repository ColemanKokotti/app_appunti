import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class ListItemFormatter {
  // Metodo da aggiungere al BaseFormatter per il riconoscimento
  static bool isListItemStart(String line) {
    return isListItem(line);
  }
  // Metodo per verificare se una riga è un elemento di lista con formato "- lettera."
  static bool isListItem(String line) {
    final trimmedLine = line.trim();

    // Regex per riconoscere il pattern "- [lettera]."
    // Supporta sia lettere minuscole che maiuscole
    final listItemRegex = RegExp(r'^-\s*[a-zA-Z]\.$');

    return listItemRegex.hasMatch(trimmedLine);
  }

  // Metodo per estrarre la lettera dall'elemento di lista
  static String extractListItemLetter(String line) {
    final trimmedLine = line.trim();
    final match = RegExp(r'^-\s*([a-zA-Z])\.$').firstMatch(trimmedLine);

    if (match != null) {
      return match.group(1) ?? '';
    }

    return '';
  }

  // Metodo per costruire il widget del titolo di lista
  static Widget buildListItemHeader(BuildContext context, String line) {
    final letter = extractListItemLetter(line);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(top: 12.0, bottom: 6.0, left: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icona bullet point
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Testo dell'elemento di lista
          Text(
            'Punto $letter',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.headingColor,
            ),
          ),
        ],
      ),
    );
  }

  // Metodo alternativo per uno stile più semplice
  static Widget buildSimpleListItemHeader(BuildContext context, String line) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      margin: const EdgeInsets.only(top: 10.0, bottom: 4.0, left: 12.0),
      child: Text(
        line.trim(),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppTheme.subheadingColor,
        ),
      ),
    );
  }

  // Metodo per costruire un paragrafo completo per elemento di lista
  static Widget buildListItemParagraph(BuildContext context, String title, List<Widget> contentWidgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header dell'elemento di lista
        buildListItemHeader(context, title),

        // Container per il contenuto dell'elemento di lista
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 12.0),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets,
          ),
        ),
      ],
    );
  }
}