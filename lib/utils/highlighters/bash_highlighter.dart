import 'package:flutter/material.dart';

import '../highlighter_utils.dart';

class BashHighlighter {
  static TextSpan highlightBash(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightBashLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightBashLine(String line) {
    final List<TextSpan> spans = [];

    final RegExp keywordPattern = RegExp(
        r'\b(alias|bg|bind|break|builtin|caller|case|cd|command|compgen|complete|compopt|continue|declare|dirs|disown|do|done|echo|elif|else|enable|esac|eval|exec|exit|export|false|fc|fg|fi|for|function|getopts|hash|help|history|if|jobs|kill|let|local|logout|mapfile|popd|printf|pushd|pwd|read|readarray|readonly|return|select|set|shift|shopt|source|suspend|test|then|time|times|trap|true|type|typeset|ulimit|umask|unalias|unset|until|wait|while)\b',
        caseSensitive: true);

    final RegExp variablePattern = RegExp(r'\$\w+|\$\{\w+\}');
    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'#.*');

    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

    String remaining = line;

    while (remaining.isNotEmpty) {
      Match? keywordMatch = keywordPattern.firstMatch(remaining);
      Match? variableMatch = variablePattern.firstMatch(remaining);
      Match? stringMatch = stringPattern.firstMatch(remaining);

      Match? firstMatch;
      String? matchType;
      int minStart = remaining.length;

      if (keywordMatch != null && keywordMatch.start < minStart) {
        firstMatch = keywordMatch;
        matchType = 'keyword';
        minStart = keywordMatch.start;
      }

      if (variableMatch != null && variableMatch.start < minStart) {
        firstMatch = variableMatch;
        matchType = 'variable';
        minStart = variableMatch.start;
      }

      if (stringMatch != null && stringMatch.start < minStart) {
        firstMatch = stringMatch;
        matchType = 'string';
        minStart = stringMatch.start;
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
            color = const Color(0xFFCD9069); // Orange-ish for Bash keywords
            weight = FontWeight.bold;
            break;
          case 'variable':
            color = const Color(0xFF9CDCFE); // Light blue for variables
            break;
          case 'string':
            color = const Color(0xFFCE9178); // Orange/brown for strings
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