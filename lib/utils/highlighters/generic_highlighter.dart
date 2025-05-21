import 'package:flutter/material.dart';

class GenericHighlighter {
  static TextSpan highlightGeneric(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      spans.add(TextSpan(
        text: lines[i],
        style: const TextStyle(color: Color(0xFFE6E6E6)),
      ));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }
}