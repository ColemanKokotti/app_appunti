import 'package:flutter/material.dart';

import '../highlighter_utils.dart';

class WebHighlighter {
  static TextSpan highlightWeb(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightWebLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightWebLine(String line) {
    final List<TextSpan> spans = [];

    // Pattern per i commenti (deve essere controllato per primo)
    final RegExp commentPattern = RegExp(r'//.*$|/\*[\s\S]*?\*/|<!--[\s\S]*?-->');

    // Se la linea è un commento, colorala tutta come commento
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

    // Pattern per HTML, CSS e JavaScript
    final RegExp htmlTagPattern = RegExp(r'<[^>]+>');
    final RegExp htmlAttributePattern = RegExp(r'\s+([a-zA-Z-]+)\s*=\s*(["\''])([^"\']*)\2');
    final RegExp cssPropertyPattern = RegExp(r'([a-zA-Z-]+)\s*:');
    final RegExp cssValuePattern = RegExp(r':\s*([^;{}]+)');
    final RegExp jsKeywordPattern = RegExp(
        r'\b(async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|if|import|in|instanceof|let|new|of|return|super|switch|this|throw|try|typeof|var|void|while|with|yield|document|window|console|alert)\b');
    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'|`[^`]*`');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?(px|em|rem|vh|vw|%|ms|s)?\b');
    final RegExp selectorPattern = RegExp(r'[.#]?[a-zA-Z][a-zA-Z0-9_-]*(?=\s*{)');

    String remaining = line;
    int currentIndex = 0;

    while (remaining.isNotEmpty && currentIndex < line.length) {
      Match? bestMatch;
      String? matchType;
      int minStart = remaining.length;

      // Trova il primo match tra tutti i pattern
      final matches = {
        'htmlTag': htmlTagPattern.firstMatch(remaining),
        'cssProperty': cssPropertyPattern.firstMatch(remaining),
        'cssValue': cssValuePattern.firstMatch(remaining),
        'jsKeyword': jsKeywordPattern.firstMatch(remaining),
        'string': stringPattern.firstMatch(remaining),
        'number': numberPattern.firstMatch(remaining),
        'selector': selectorPattern.firstMatch(remaining),
      };

      for (final entry in matches.entries) {
        final match = entry.value;
        if (match != null && match.start < minStart) {
          bestMatch = match;
          matchType = entry.key;
          minStart = match.start;
        }
      }

      if (bestMatch != null) {
        // Aggiungi il testo normale prima del match
        if (bestMatch.start > 0) {
          spans.add(TextSpan(
            text: remaining.substring(0, bestMatch.start),
            style: const TextStyle(color: Color(0xFFE6E6E6)),
          ));
        }

        final String matchText = bestMatch.group(0)!;

        switch (matchType) {
          case 'htmlTag':
            _processHtmlTag(spans, matchText);
            break;
          case 'cssProperty':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFF9CDCFE), // Blu chiaro per proprietà CSS
                fontWeight: FontWeight.w500,
              ),
            ));
            break;
          case 'cssValue':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFFCE9178), // Arancione per valori CSS
              ),
            ));
            break;
          case 'jsKeyword':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFFC586C0), // Viola per keyword JavaScript
                fontWeight: FontWeight.bold,
              ),
            ));
            break;
          case 'string':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFFCE9178), // Arancione per stringhe
              ),
            ));
            break;
          case 'number':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFFB5CEA8), // Verde chiaro per numeri
              ),
            ));
            break;
          case 'selector':
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(
                color: Color(0xFFD7BA7D), // Giallo per selettori CSS
                fontWeight: FontWeight.w500,
              ),
            ));
            break;
          default:
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(color: Color(0xFFE6E6E6)),
            ));
        }

        remaining = remaining.substring(bestMatch.start + matchText.length);
        currentIndex += bestMatch.start + matchText.length;
      } else {
        // Nessun match trovato, aggiungi il resto come testo normale
        spans.add(TextSpan(
          text: remaining,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
        break;
      }
    }

    return spans;
  }

  static void _processHtmlTag(List<TextSpan> spans, String tagText) {
    // Pattern per identificare parti del tag HTML
    final RegExp tagNamePattern = RegExp(r'^</?([^\s>]+)');
    final RegExp attributePattern = RegExp(r'\s+([a-zA-Z-]+)(?:\s*=\s*(["\''])([^"\']*)\2)?');

    int currentIndex = 0;

    // Trova il nome del tag
    final tagNameMatch = tagNamePattern.firstMatch(tagText);
    if (tagNameMatch != null) {
      // Aggiungi '<' o '</'
      spans.add(TextSpan(
        text: tagText.substring(0, tagNameMatch.start + 1),
        style: const TextStyle(color: Color(0xFF808080)), // Grigio per brackets
      ));

      // Aggiungi il nome del tag
      spans.add(TextSpan(
        text: tagNameMatch.group(1)!,
        style: const TextStyle(
          color: Color(0xFF569CD6), // Blu per nome tag
          fontWeight: FontWeight.bold,
        ),
      ));

      currentIndex = tagNameMatch.end;

      // Trova tutti gli attributi
      String remainingTag = tagText.substring(currentIndex);
      final attributeMatches = attributePattern.allMatches(remainingTag).toList();

      int lastEnd = 0;
      for (final attrMatch in attributeMatches) {
        // Aggiungi spazi prima dell'attributo
        if (attrMatch.start > lastEnd) {
          spans.add(TextSpan(
            text: remainingTag.substring(lastEnd, attrMatch.start),
            style: const TextStyle(color: Color(0xFFE6E6E6)),
          ));
        }

        // Nome attributo
        spans.add(TextSpan(
          text: attrMatch.group(1)!,
          style: const TextStyle(
            color: Color(0xFF9CDCFE), // Blu chiaro per attributi
          ),
        ));

        // Se c'è un valore
        if (attrMatch.group(2) != null && attrMatch.group(3) != null) {
          // '=' e quote
          spans.add(TextSpan(
            text: '=${attrMatch.group(2)!}',
            style: const TextStyle(color: Color(0xFFE6E6E6)),
          ));

          // Valore attributo
          spans.add(TextSpan(
            text: attrMatch.group(3)!,
            style: const TextStyle(
              color: Color(0xFFCE9178), // Arancione per valori attributo
            ),
          ));

          // Quote di chiusura
          spans.add(TextSpan(
            text: attrMatch.group(2)!,
            style: const TextStyle(color: Color(0xFFE6E6E6)),
          ));
        }

        lastEnd = attrMatch.end;
      }

      // Aggiungi il resto del tag (incluso '>')
      if (lastEnd < remainingTag.length) {
        spans.add(TextSpan(
          text: remainingTag.substring(lastEnd),
          style: const TextStyle(color: Color(0xFF808080)), // Grigio per '>'
        ));
      }
    } else {
      // Se non riusciamo a parsare il tag, coloralo tutto come tag
      spans.add(TextSpan(
        text: tagText,
        style: const TextStyle(
          color: Color(0xFF569CD6),
          fontWeight: FontWeight.bold,
        ),
      ));
    }
  }
}