import 'package:flutter/material.dart';

import '../highlighter_utils.dart';

class SwiftHighlighter {
  static TextSpan highlightSwift(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightSwiftLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightSwiftLine(String line) {
    final List<TextSpan> spans = [];

    final RegExp keywordPattern = RegExp(
        r'\b(actor|Any|as|associatedtype|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|do|dynamicCallable|dynamicMemberLookup|else|enum|extension|fallthrough|false|fileprivate|final|for|func|get|guard|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|let|macro|mutating|nil|nonisolated|open|operator|optional|override|postfix|precedencegroup|prefix|private|protocol|public|repeat|required|rethrows|return|self|set|some|static|struct|subscript|super|switch|throw|throws|true|try|typealias|unowned|var|weak|where|while|willSet|yield)\b',
        caseSensitive: true);

    final RegExp typePattern = RegExp(
        r'\b(Bool|Character|Double|Float|Int|Int8|Int16|Int32|Int64|Never|Optional|String|UInt|UInt8|UInt16|UInt32|UInt64|Void)\b',
        caseSensitive: true);

    final RegExp stringPattern = RegExp(r'"[^"]*"');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

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
            color = const Color(0xFFFF7AB2); // Pink for Swift keywords
            weight = FontWeight.bold;
            break;
          case 'type':
            color = const Color(0xFF4EC9B0); // Aqua for types
            break;
          case 'string':
            color = const Color(0xFFCE9178); // Orange/brown for strings
            break;
          case 'number':
            color = const Color(0xFFB5CEA8); // Light green for numbers
            break;
          default:
            color = const Color(0xFFE6E6E6); // White for normal text
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