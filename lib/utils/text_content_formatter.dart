import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class TextContentFormatter {
  // Questo metodo costruisce un RichText con stili diversi per parti differenti del testo
  static Widget buildRichText(String line, bool isDefinition) {
    final List<TextSpan> spans = [];

    // Caso di testo con i due punti
    if (line.contains(':')) {
      final parts = line.split(':');

      // Parte prima dei due punti (il sottotitolo)
      spans.add(TextSpan(
        text: '${parts[0]}:',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.subheadingColor, // Colore per il sottotitolo
        ),
      ));

      // Parte dopo i due punti (se esiste)
      if (parts.length > 1) {
        spans.add(TextSpan(
          text: parts.sublist(1).join(':'),
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
}
