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

    // HTML tag pattern
    final RegExp htmlTagPattern = RegExp(r'<[^>]+>');
    // HTML attribute pattern
    final RegExp htmlAttributePattern = RegExp(r'\s(\w+)=["\''][^\'"]+["\''']');
    // CSS properties
    final RegExp cssPropertyPattern = RegExp(r'[\w-]+\s*:');
    // JavaScript keywords
    final RegExp jsKeywordPattern = RegExp(
        r'\b(async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|if|import|in|instanceof|let|new|of|return|super|switch|this|throw|try|typeof|var|void|while|with|yield)\b',
        caseSensitive: true);
    // Common patterns
    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/|');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?(px|em|rem|vh|vw|%)?\b');

    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

    String remaining = line;

    void processHtmlTag(List<TextSpan> spans, String matchText) {
      String tagText = matchText;
      List<TextSpan> tagSpans = [];

      RegExp tagNameRegex = RegExp(r'</?([^\s>]*)');
      Match? tagNameMatch = tagNameRegex.firstMatch(tagText);

      if (tagNameMatch != null) {
        String tagOpen = tagNameMatch.group(0)!;

        tagSpans.add(TextSpan(
          text: tagOpen[0],
          style: const TextStyle(color: Color(0xFF808080)),
        ));

        if (tagOpen.length > 1) {
          tagSpans.add(TextSpan(
            text: tagOpen.substring(1),
            style: const TextStyle(
              color: Color(0xFF569CD6),
              fontWeight: FontWeight.bold,
            ),
          ));
        }

        String attributesPart = tagText.substring(tagNameMatch.end);

        while (attributesPart.isNotEmpty) {
          Match? attrNameMatch = htmlAttributePattern.firstMatch(attributesPart);

          if (attrNameMatch != null) {
            tagSpans.add(TextSpan(
              text: attrNameMatch.group(1), // Whitespace
              style: const TextStyle(color: Color(0xFFE6E6E6)),
            ));

            tagSpans.add(TextSpan(
              text: attrNameMatch.group(2), // Attribute name
              style: const TextStyle(color: Color(0xFF9CDCFE)),
            ));

            tagSpans.add(TextSpan(
              text: attrNameMatch.group(3), // Equals sign
              style: const TextStyle(color: Color(0xFFE6E6E6)),
            ));

            attributesPart = attributesPart.substring(attrNameMatch.end);

            Match? attrValueMatch = stringPattern.firstMatch(attributesPart);
            if (attrValueMatch != null) {
              tagSpans.add(TextSpan(
                text: attrValueMatch.group(0),
                style: const TextStyle(color: Color(0xFFCE9178)),
              ));
              attributesPart = attributesPart.substring(attrValueMatch.end);
            }
          } else {
            tagSpans.add(TextSpan(
              text: attributesPart,
              style: const TextStyle(color: Color(0xFF808080)),
            ));
            break;
          }
        }
        spans.addAll(tagSpans);
      } else {
        spans.add(TextSpan(
          text: matchText,
          style: const TextStyle(color: Color(0xFF569CD6)),
        ));
      }
    }

    while (remaining.isNotEmpty) {
      Match? htmlTagMatch = htmlTagPattern.firstMatch(remaining);
      Match? cssPropertyMatch = cssPropertyPattern.firstMatch(remaining);
      Match? jsKeywordMatch = jsKeywordPattern.firstMatch(remaining);
      Match? stringMatch = stringPattern.firstMatch(remaining);
      Match? numberMatch = numberPattern.firstMatch(remaining);

      Match? firstMatch;
      String? matchType;
      int minStart = remaining.length;

      if (htmlTagMatch != null && htmlTagMatch.start < minStart) {
        firstMatch = htmlTagMatch;
        matchType = 'htmlTag';
        minStart = htmlTagMatch.start;
      }

      if (cssPropertyMatch != null && cssPropertyMatch.start < minStart) {
        firstMatch = cssPropertyMatch;
        matchType = 'cssProperty';
        minStart = cssPropertyMatch.start;
      }

      if (jsKeywordMatch != null && jsKeywordMatch.start < minStart) {
        firstMatch = jsKeywordMatch;
        matchType = 'jsKeyword';
        minStart = jsKeywordMatch.start;
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
          case 'htmlTag':
            processHtmlTag(spans, matchText);
            break;
          case 'cssProperty':
            color = const Color(0xFF9CDCFE); // Light blue for CSS properties
            spans.add(TextSpan(
              text: matchText,
              style: TextStyle(
                color: color,
                fontWeight: weight,
              ),
            ));
            break;
          case 'jsKeyword':
            color = const Color(0xFFC586C0); // Purple for JS keywords
            weight = FontWeight.bold;
            spans.add(TextSpan(
              text: matchText,
              style: TextStyle(
                color: color,
                fontWeight: weight,
              ),
            ));
            break;
          case 'string':
            color = const Color(0xFFCE9178); // Orange/brown for strings
            spans.add(TextSpan(
              text: matchText,
              style: TextStyle(
                color: color,
                fontWeight: weight,
              ),
            ));
            break;
          case 'number':
            color = const Color(0xFFB5CEA8); // Light green for numbers
            spans.add(TextSpan(
              text: matchText,
              style: TextStyle(
                color: color,
                fontWeight: weight,
              ),
            ));
            break;
          default:
            HighlighterUtils.addNormalText(spans, matchText);
        }

        remaining = remaining.substring(firstMatch.start + matchText.length);
      } else {
        HighlighterUtils.addNormalText(spans, remaining);
        break;
      }
    }

    return spans;
  }
}