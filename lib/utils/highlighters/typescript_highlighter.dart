import 'package:flutter/material.dart';

import '../highlighter_utils.dart';

class TypeScriptHighlighter {
  static TextSpan highlightTypeScript(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightTypeScriptLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightTypeScriptLine(String line) {
    final List<TextSpan> spans = [];

    final RegExp keywordPattern = RegExp(
        r'\b(abstract|any|as|async|await|boolean|break|case|catch|class|const|constructor|continue|debugger|declare|default|delete|do|else|enum|export|extends|false|finally|for|from|function|get|if|implements|import|in|infer|instanceof|interface|is|keyof|let|module|namespace|never|new|null|number|object|of|package|private|protected|public|readonly|require|return|set|static|string|super|switch|symbol|this|throw|true|try|type|typeof|undefined|unique|unknown|var|void|while|with|yield)\b',
        caseSensitive: true);

    final RegExp typePattern = RegExp(
        r'\b(Array|Boolean|Date|Error|Function|Map|Number|Object|Promise|RegExp|Set|String|Symbol|WeakMap|WeakSet)\b',
        caseSensitive: true);

    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'|`[^`]*`');
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
            color = const Color(0xFF569CD6); // Blue for keywords
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