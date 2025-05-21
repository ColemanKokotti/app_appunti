import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import 'text_content_formatter.dart';

class ParagraphFormatter {
  static Widget buildParagraphHeader(BuildContext context, String title) {
    return Container(
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
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.headingColor,
        ),
      ),
    );
  }

  static Widget buildParagraphContent(BuildContext context, List<String> content) {
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