import 'package:flutter/material.dart';

class SyntaxHighlighter {
  static TextSpan highlightCode(String code, String language) {
    switch (language.toLowerCase()) {
      case 'c#':
        return highlightCSharp(code);
      case 'kotlin':
        return highlightKotlin(code);
      case 'typescript':
        return highlightTypeScript(code);
      case 'swift':
        return highlightSwift(code);
      case 'bash':
        return highlightBash(code);
      case 'dart':
        return highlightDart(code);
      case 'html/css/javascript':
        return highlightWeb(code);
      default:
        return highlightGeneric(code);
    }
  }

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

    // Regex patterns per l'evidenziazione
    final RegExp keywordPattern = RegExp(
        r'\b(abstract|as|base|bool|break|byte|case|catch|char|checked|class|const|continue|decimal|default|delegate|do|double|else|enum|event|explicit|extern|false|finally|fixed|float|for|foreach|goto|if|implicit|in|int|interface|internal|is|lock|long|namespace|new|null|object|operator|out|override|params|private|protected|public|readonly|ref|return|sbyte|sealed|short|sizeof|stackalloc|static|string|struct|switch|this|throw|true|try|typeof|uint|ulong|unchecked|unsafe|ushort|using|virtual|void|volatile|while)\b',
        caseSensitive: true
    );

    final RegExp typePattern = RegExp(
        r'\b(bool|byte|char|decimal|double|float|int|long|object|sbyte|short|string|uint|ulong|ushort|var|void)\b',
        caseSensitive: true
    );

    final RegExp stringPattern = RegExp(r'"[^"]*"');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    // Controlla se la riga è un commento
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      // Parte prima del commento
      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      // Il commento stesso
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)), // Verde per i commenti
      ));

      // Parte dopo il commento
      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    // Tokenizzazione e colorazione
    String remaining = line;

    // Funzione per aggiungere uno span di testo normale
    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

    while (remaining.isNotEmpty) {
      // Cerca keywordPattern
      Match? keywordMatch = keywordPattern.firstMatch(remaining);
      // Cerca typePattern
      Match? typeMatch = typePattern.firstMatch(remaining);
      // Cerca stringPattern
      Match? stringMatch = stringPattern.firstMatch(remaining);
      // Cerca numberPattern
      Match? numberMatch = numberPattern.firstMatch(remaining);

      // Trova il match più vicino all'inizio
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
        // Aggiungi il testo normale prima del match
        if (firstMatch.start > 0) {
          addNormalText(remaining.substring(0, firstMatch.start));
        }

        // Aggiungi il match con lo stile appropriato
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

        // Aggiorna il testo rimanente
        remaining = remaining.substring(firstMatch.start + matchText.length);
      } else {
        // Nessun altro match, aggiungi il resto del testo
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

// Enhanced Kotlin syntax highlighting with Compose support
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

    // Regex patterns for Kotlin
    final RegExp keywordPattern = RegExp(
        r'\b(abstract|actual|annotation|as|break|by|catch|class|companion|const|constructor|continue|crossinline|data|do|dynamic|else|enum|expect|external|false|field|final|finally|for|fun|get|if|import|in|infix|init|inline|inner|interface|internal|is|lateinit|noinline|null|object|open|operator|out|override|package|private|protected|public|reified|return|sealed|set|super|suspend|tailrec|this|throw|true|try|typealias|val|var|vararg|when|where|while)\b',
        caseSensitive: true
    );

    // Added Compose keywords
    final RegExp composeKeywordPattern = RegExp(
        r'\b(Composable|remember|derivedStateOf|produceState|LaunchedEffect|DisposableEffect|SideEffect|rememberCoroutineScope|rememberUpdatedState|rememberSaveable|mutableStateOf|rememberSaveable|collectAsState)\b',
        caseSensitive: true
    );

    final RegExp typePattern = RegExp(
        r'\b(Any|Boolean|Byte|Char|Double|Float|Int|Long|Nothing|Short|String|Unit)\b',
        caseSensitive: true
    );

    // Added Compose types
    final RegExp composeTypePattern = RegExp(
        r'\b(Column|Row|Box|Spacer|Text|Button|Surface|Card|Scaffold|TopAppBar|BottomAppBar|FloatingActionButton|Icon|Image|LazyColumn|LazyRow|Modifier|Color|State|MutableState|Dp|BoxScope|RowScope|ColumnScope|CompositionLocal|MaterialTheme|TextStyle|FontWeight|LocalContext|LocalDensity|LocalLayoutDirection)\b',
        caseSensitive: true
    );

    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');
    final RegExp annotationPattern = RegExp(r'@\w+');

    // Apply highlighting logic
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

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
          addNormalText(remaining.substring(0, firstMatch.start));
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

// New XML syntax highlighting
  static TextSpan highlightXml(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightXmlLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  static List<TextSpan> _highlightXmlLine(String line) {
    final List<TextSpan> spans = [];

    // XML patterns
    final RegExp tagPattern = RegExp(r'</?[a-zA-Z][^>]*>|</?>');
    final RegExp attrNamePattern = RegExp(r'(\s+)([a-zA-Z:_][a-zA-Z0-9:_\-\.]*)(=)');
    final RegExp attrValuePattern = RegExp(r'("[^"]*"|\''[^\']*\')');
    final RegExp commentPattern = RegExp(r'<!--.*?-->');
    final RegExp cdataPattern = RegExp(r'<!\[CDATA\[.*?\]\]>');
    final RegExp entityPattern = RegExp(r'&[a-zA-Z0-9#]+;');

    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

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

    if (cdataPattern.hasMatch(line)) {
      final Match match = cdataPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFFD7BA7D)), // Orange-ish for CDATA
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

    while (remaining.isNotEmpty) {
      Match? tagMatch = tagPattern.firstMatch(remaining);
      Match? entityMatch = entityPattern.firstMatch(remaining);

      Match? firstMatch;
      String? matchType;
      int minStart = remaining.length;

      if (tagMatch != null && tagMatch.start < minStart) {
        firstMatch = tagMatch;
        matchType = 'tag';
        minStart = tagMatch.start;
      }

      if (entityMatch != null && entityMatch.start < minStart) {
        firstMatch = entityMatch;
        matchType = 'entity';
        minStart = entityMatch.start;
      }

      if (firstMatch != null) {
        if (firstMatch.start > 0) {
          addNormalText(remaining.substring(0, firstMatch.start));
        }

        final String matchText = firstMatch.group(0)!;

        if (matchType == 'tag') {
          // Process the tag to highlight attributes
          String tagText = matchText;
          List<TextSpan> tagSpans = [];

          // Tag brackets and name
          RegExp tagNameRegex = RegExp(r'</?([^\s>]*)');
          Match? tagNameMatch = tagNameRegex.firstMatch(tagText);

          if (tagNameMatch != null) {
            String tagOpen = tagNameMatch.group(0)!;

            // Opening bracket and tag name
            tagSpans.add(TextSpan(
              text: tagOpen[0], // < or </
              style: const TextStyle(color: Color(0xFF808080)), // Gray for brackets
            ));

            if (tagOpen.length > 1) {
              tagSpans.add(TextSpan(
                text: tagOpen.substring(1),
                style: const TextStyle(
                  color: Color(0xFF569CD6), // Blue for tag names
                  fontWeight: FontWeight.bold,
                ),
              ));
            }

            // Process attributes
            String attributesPart = tagText.substring(tagNameMatch.end);

            while (attributesPart.isNotEmpty) {
              Match? attrNameMatch = attrNamePattern.firstMatch(attributesPart);

              if (attrNameMatch != null) {
                // Whitespace before attribute
                tagSpans.add(TextSpan(
                  text: attrNameMatch.group(1),
                  style: const TextStyle(color: Color(0xFFE6E6E6)),
                ));

                // Attribute name
                tagSpans.add(TextSpan(
                  text: attrNameMatch.group(2),
                  style: const TextStyle(color: Color(0xFF9CDCFE)), // Light blue for attribute names
                ));

                // Equals sign
                tagSpans.add(TextSpan(
                  text: attrNameMatch.group(3),
                  style: const TextStyle(color: Color(0xFFE6E6E6)),
                ));

                attributesPart = attributesPart.substring(attrNameMatch.end);

                // Attribute value
                Match? attrValueMatch = attrValuePattern.firstMatch(attributesPart);
                if (attrValueMatch != null) {
                  tagSpans.add(TextSpan(
                    text: attrValueMatch.group(0),
                    style: const TextStyle(color: Color(0xFFCE9178)), // Orange/brown for attribute values
                  ));
                  attributesPart = attributesPart.substring(attrValueMatch.end);
                }
              } else {
                // Closing part of tag including >
                tagSpans.add(TextSpan(
                  text: attributesPart,
                  style: const TextStyle(color: Color(0xFF808080)), // Gray for brackets
                ));
                break;
              }
            }

            spans.addAll(tagSpans);
          } else {
            // Fallback if regex fails
            spans.add(TextSpan(
              text: matchText,
              style: const TextStyle(color: Color(0xFF569CD6)),
            ));
          }
        } else if (matchType == 'entity') {
          spans.add(TextSpan(
            text: matchText,
            style: const TextStyle(color: Color(0xFFD7BA7D)), // Orange-ish for entities
          ));
        }

        remaining = remaining.substring(firstMatch.start + matchText.length);
      } else {
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // TypeScript syntax highlighting
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

    // TypeScript specific patterns
    final RegExp keywordPattern = RegExp(
        r'\b(abstract|any|as|async|await|boolean|break|case|catch|class|const|constructor|continue|debugger|declare|default|delete|do|else|enum|export|extends|false|finally|for|from|function|get|if|implements|import|in|infer|instanceof|interface|is|keyof|let|module|namespace|never|new|null|number|object|of|package|private|protected|public|readonly|require|return|set|static|string|super|switch|symbol|this|throw|true|try|type|typeof|undefined|unique|unknown|var|void|while|with|yield)\b',
        caseSensitive: true
    );

    final RegExp typePattern = RegExp(
        r'\b(Array|Boolean|Date|Error|Function|Map|Number|Object|Promise|RegExp|Set|String|Symbol|WeakMap|WeakSet)\b',
        caseSensitive: true
    );

    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'|`[^`]*`');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    // Apply the highlighting using the same pattern as before but with TypeScript patterns
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

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
          addNormalText(remaining.substring(0, firstMatch.start));
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // Swift syntax highlighting
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

    // Swift specific patterns
    final RegExp keywordPattern = RegExp(
        r'\b(actor|Any|as|associatedtype|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|do|dynamicCallable|dynamicMemberLookup|else|enum|extension|fallthrough|false|fileprivate|final|for|func|get|guard|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|let|macro|mutating|nil|nonisolated|open|operator|optional|override|postfix|precedencegroup|prefix|private|protocol|public|repeat|required|rethrows|return|self|set|some|static|struct|subscript|super|switch|throw|throws|true|try|typealias|unowned|var|weak|where|while|willSet|yield)\b',
        caseSensitive: true
    );

    final RegExp typePattern = RegExp(
        r'\b(Bool|Character|Double|Float|Int|Int8|Int16|Int32|Int64|Never|Optional|String|UInt|UInt8|UInt16|UInt32|UInt64|Void)\b',
        caseSensitive: true
    );

    final RegExp stringPattern = RegExp(r'"[^"]*"');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    // Apply the highlighting using the same pattern as before but with Swift patterns
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

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
          addNormalText(remaining.substring(0, firstMatch.start));
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // Bash syntax highlighting
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

    // Bash specific patterns
    final RegExp keywordPattern = RegExp(
        r'\b(alias|bg|bind|break|builtin|caller|case|cd|command|compgen|complete|compopt|continue|declare|dirs|disown|do|done|echo|elif|else|enable|esac|eval|exec|exit|export|false|fc|fg|fi|for|function|getopts|hash|help|history|if|jobs|kill|let|local|logout|mapfile|popd|printf|pushd|pwd|read|readarray|readonly|return|select|set|shift|shopt|source|suspend|test|then|time|times|trap|true|type|typeset|ulimit|umask|unalias|unset|until|wait|while)\b',
        caseSensitive: true
    );

    final RegExp variablePattern = RegExp(r'\$\w+|\$\{\w+\}');
    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'#.*');

    // Apply the highlighting logic
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

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
          addNormalText(remaining.substring(0, firstMatch.start));
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // Dart syntax highlighting
  static TextSpan highlightDart(String code) {
    final List<TextSpan> spans = [];
    final List<String> lines = code.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      final List<TextSpan> lineSpans = _highlightDartLine(line);

      spans.add(TextSpan(children: lineSpans));

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }
  static List<TextSpan> _highlightDartLine(String line) {
    final List<TextSpan> spans = [];

    // Dart specific patterns
    final RegExp keywordPattern = RegExp(
        r'\b(abstract|as|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|false|final|finally|for|Function|get|hide|if|implements|import|in|interface|is|late|library|mixin|new|null|on|operator|part|required|rethrow|return|set|show|static|super|switch|sync|this|throw|true|try|typedef|var|void|while|with|yield)\b',
        caseSensitive: true
    );

    final RegExp typePattern = RegExp(
        r'\b(bool|double|int|num|String|List|Map|Set|Future|Stream)\b',
        caseSensitive: true
    );

    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?\b');

    // Apply the highlighting logic
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }
    }

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
          addNormalText(remaining.substring(0, firstMatch.start));
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // Web (HTML/CSS/JavaScript) syntax highlighting
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
        caseSensitive: true
    );
    // Common patterns
    final RegExp stringPattern = RegExp(r'"[^"]*"|\''[^\']*\'');
    final RegExp commentPattern = RegExp(r'//.*|/\*[\s\S]*?\*/|<!--[\s\S]*?-->');
    final RegExp numberPattern = RegExp(r'\b\d+(\.\d+)?(px|em|rem|vh|vw|%)?\b');

    // Apply the highlighting logic
    if (commentPattern.hasMatch(line)) {
      final Match match = commentPattern.firstMatch(line)!;

      if (match.start > 0) {
        spans.add(TextSpan(
          text: line.substring(0, match.start),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(color: Color(0xFF6A9955)),
      ));

      if (match.end < line.length) {
        spans.add(TextSpan(
          text: line.substring(match.end),
          style: const TextStyle(color: Color(0xFFE6E6E6)),
        ));
      }

      return spans;
    }

    String remaining = line;

    void addNormalText(String text) {
      if (text.isNotEmpty) {
        spans.add(TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xFFE6E6E6)),
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
          addNormalText(remaining.substring(0, firstMatch.start));
        }

        final String matchText = firstMatch.group(0)!;
        Color color;
        FontWeight weight = FontWeight.normal;

        switch (matchType) {
          case 'htmlTag':
            color = const Color(0xFF569CD6); // Blue for HTML tags
            break;
          case 'cssProperty':
            color = const Color(0xFF9CDCFE); // Light blue for CSS properties
            break;
          case 'jsKeyword':
            color = const Color(0xFFC586C0); // Purple for JS keywords
            weight = FontWeight.bold;
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
        addNormalText(remaining);
        break;
      }
    }

    return spans;
  }

  // Generic syntax highlighting for unknown languages
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

  // Funzione per identificare il linguaggio dal nome del file
  static String identifyLanguageFromFilename(String filename) {
    if (filename.contains('Schema_Programming_Fundamentals')) {
      return 'c#';
    } else if (filename.contains('Schema_Android')) {
      return 'kotlin';
    } else if (filename.contains('Schema_React')) {
      return 'typescript';
    } else if (filename.contains('Schema_IOS')) {
      return 'swift';
    } else if (filename.contains('Schema_Linux')) {
      return 'bash';
    } else if (filename.contains('Schema_Flutter')) {
      return 'dart';
    } else if (filename.contains('Schema_Web')) {
      return 'html/css/javascript';
    } else {
      return 'generic';
    }
  }
}
