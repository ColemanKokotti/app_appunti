import 'package:flutter/material.dart';

import '../highlighter_utils.dart';


class KotlinHighlighter {
  static TextSpan highlightKotlin(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightKotlinLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightKotlinLine(String line) {
    final List<TextSpan> spans = [];

    final RegExp keywordPattern = RegExp(
        r'\b(abstract|actual|annotation|as|break|by|catch|class|companion|const|constructor|continue|crossinline|data|do|dynamic|else|enum|expect|external|false|field|final|finally|for|fun|get|if|import|in|infix|init|inline|inner|interface|internal|is|lateinit|noinline|null|object|open|operator|out|override|package|private|protected|public|reified|return|sealed|set|super|suspend|tailrec|this|throw|true|try|typealias|val|var|vararg|when|where|while)\b',
        caseSensitive: true);

    final RegExp composeKeywordPattern = RegExp(
        r'\b(Composable|remember|derivedStateOf|produceState|LaunchedEffect|DisposableEffect|SideEffect|rememberCoroutineScope|rememberUpdatedState|rememberSaveable|mutableStateOf|rememberSaveable|collectAsState)\b',
        caseSensitive: true);

    final RegExp typePattern = RegExp(
        r'\b(Any|Boolean|Byte|Char|Double|Float|Int|Long|Nothing|Short|String|Unit)\b',
        caseSensitive: true);

    final RegExp composeTypePattern = RegExp(
        r'\b(Column|Row|Box|Spacer|Text|Button|Surface|Card|Scaffold|TopAppBar|BottomAppBar|FloatingActionButton|Icon|Image|LazyColumn|LazyRow|Modifier|Color|State|MutableState|Dp|BoxScope|RowScope|ColumnScope|CompositionLocal|MaterialTheme|TextStyle|FontWeight|LocalContext|LocalDensity|LocalLayoutDirection)\b',
        caseSensitive: true);

    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');
    final RegExp annotationPattern = RegExp(r'@\w+');

    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;
      return HighlighterUtils.applyCommentHighlight(line, match);
    }

    String remaining = line;

    while (remaining.isNotEmpty) {
      Match? keywordMatch = keywordPattern.firstMatch(remaining);
      Match? composeKeywordMatch = composeKeywordPattern.firstMatch(remaining);
      Match? typeMatch = typePattern.firstMatch(remaining);
      Match? composeTypeMatch = composeTypePattern.firstMatch(remaining);
      Match? stringMatch = stringPattern.firstMatch(remaining);
      Match? numberMatch = numberPattern.firstMatch(remaining);
      Match? annotationMatch = annotationPattern.firstMatch(remaining);

      Match? firstMatch;
      String? matchType;
      int minStart = remaining.length;

      if (keywordMatch != null && keywordMatch.start < minStart) {
        firstMatch = keywordMatch;
        matchType = 'keyword';
        minStart = keywordMatch.start;
      }

      if (composeKeywordMatch != null && composeKeywordMatch.start < minStart) {
        firstMatch = composeKeywordMatch;
        matchType = 'composeKeyword';
        minStart = composeKeywordMatch.start;
      }

      if (typeMatch != null && typeMatch.start < minStart) {
        firstMatch = typeMatch;
        matchType = 'type';
        minStart = typeMatch.start;
      }

      if (composeTypeMatch != null && composeTypeMatch.start < minStart) {
        firstMatch = composeTypeMatch;
        matchType = 'composeType';
        minStart = composeTypeMatch.start;
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

      if (annotationMatch != null && annotationMatch.start < minStart) {
        firstMatch = annotationMatch;
        matchType = 'annotation';
        minStart = annotationMatch.start;
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
            color = const Color(0xFFC679DD); // Purple for Kotlin keywords
            weight = FontWeight.bold;
            break;
          case 'composeKeyword':
            color = const Color(0xFFD19A66); // Orange for Compose keywords
            weight = FontWeight.bold;
            break;
          case 'type':
            color = const Color(0xFF4EC9B0); // Aqua for types
            break;
          case 'composeType':
            color = const Color(0xFF56B6C2); // Light blue for Compose types
            break;
          case 'string':
            color = const Color(0xFFCE9178); // Orange/brown for strings
            break;
          case 'number':
            color = const Color(0xFFB5CEA8); // Light green for numbers
            break;
          case 'annotation':
            color = const Color(0xFFD19A66); // Orange for annotations
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