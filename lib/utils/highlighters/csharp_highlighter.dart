import 'package:flutter/material.dart';

import '../highlighter_utils.dart';

class CSharpHighlighter {
  static TextSpan highlightCSharp(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightCSharpLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightCSharpLine(String line) {
    final List<TextSpan> spans = [];

    final RegExp keywordPattern = RegExp(
        r'\b(abstract|as|base|bool|break|byte|case|catch|char|checked|class|const|continue|decimal|default|delegate|do|double|else|enum|event|explicit|extern|false|finally|fixed|float|for|foreach|goto|if|implicit|in|int|interface|internal|is|lock|long|namespace|new|null|object|operator|out|override|params|private|protected|public|readonly|ref|return|sbyte|sealed|short|sizeof|stackalloc|static|string|struct|switch|this|throw|true|try|typeof|uint|ulong|unchecked|unsafe|ushort|using|virtual|void|volatile|while)\b',
        caseSensitive: true);

    final RegExp typePattern = RegExp(
        r'\b(bool|byte|char|decimal|double|float|int|long|object|sbyte|short|string|uint|ulong|ushort|var|void)\b',
        caseSensitive: true);

    final RegExp stringPattern = RegExp(r'"[^"]*"');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    // Controlla se la riga è un commento
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

    // Tokenizzazione e colorazione
    String remaining = line;

    while (remaining.isNotEmpty) {
      Match? keywordMatch = keywordPattern.firstMatch(remaining);
      Match? typeMatch = typePattern.firstMatch(remaining);
      Match? stringMatch = stringPattern.firstMatch(remaining);
      Match? numberMatch = numberPattern.firstMatch(remaining);

      Match? firstMatch;
      String? matchType;
      int minStart = remaining.length;

      if (keywordMatch != null && keywordMatch.start < minStart) {
        firstMatch = keywordMatch;
        matchType = 'keyword';
        minStart = keywordMatch.start;
      }

      if (typeMatch != null && typeMatch.start < minStart) {
        firstMatch = typeMatch;
        matchType = 'type';
        minStart = typeMatch.start;
      }

      if (stringMatch != null && stringMatch.start < minStart) {
        firstMatch = stringMatch;
        matchType = 'string';
        minStart = stringMatch.start;
      }

      if (numberMatch != null && numberMatch.start < minStart) {
        firstMatch = numberMatch;
        matchType = 'number';
        minStart = numberMatch.start;
      }

      if (firstMatch != null) {
        if (firstMatch.start > 0) {
          HighlighterUtils.addNormalText(
              spans, remaining.substring(0, firstMatch.start));
        }

        final String matchText = firstMatch.group(0)!;
        Color color;
        FontWeight weight = FontWeight.normal;

        switch (matchType) {
          case 'keyword':
            color = const Color(0xFF569CD6); // Blu per le keyword
            weight = FontWeight.bold;
            break;
          case 'type':
            color = const Color(0xFF4EC9B0); // Verde acqua per i tipi
            break;
          case 'string':
            color = const Color(0xFFCE9178); // Arancione/marroncino per le stringhe
            break;
          case 'number':
            color = const Color(0xFFB5CEA8); // Verde chiaro per i numeri
            break;
          default:
            color = const Color(0xFFE6E6E6); // Bianco per il testo normale
        }

        spans.add(TextSpan(
          text: matchText,
          style: TextStyle(
            color: color,
            fontWeight: weight,
          ),
        ));

        remaining = remaining.substring(firstMatch.start + matchText.length);
      } else {
        HighlighterUtils.addNormalText(spans, remaining);
        break;
      }
    }

    return spans;
  }
}