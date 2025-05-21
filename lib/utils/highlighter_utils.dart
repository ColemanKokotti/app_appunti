import 'package:flutter/material.dart';

class HighlighterUtils {
  static void addNormalText(List<TextSpan> spans, String text) {
    if (text.isNotEmpty) {
      spans.add(TextSpan(
        text: text,
        style: const TextStyle(color: Color(0xFFE6E6E6)),
      ));
    }
  }

  static List<TextSpan> applyCommentHighlight(String line, Match match) {
    final List<TextSpan> spans = [];
    if (match.start > 0) {
      spans.add(TextSpan(
        text: line.substring(0, match.start),
        style: const TextStyle(color: Color(0xFFE6E6E6)),
      ));
    }

    spans.add(TextSpan(
      text: match.group(0),
      style: const TextStyle(color: Color(0xFF6A9955)), // Green for comments
    ));

    if (match.end < line.length) {
      spans.add(TextSpan(
        text: line.substring(match.end),
        style: const TextStyle(color: Color(0xFFE6E6E6)),
      ));
    }
    return spans;
  }
}