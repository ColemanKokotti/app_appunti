import 'package:flutter/material.dart';

import 'highlighters/bash_highlighter.dart';
import 'highlighters/csharp_highlighter.dart';
import 'highlighters/dart_highlighter.dart';
import 'highlighters/generic_highlighter.dart';
import 'highlighters/kotlin_highlighter.dart';
import 'highlighters/swift_highlighter.dart';
import 'highlighters/typescript_highlighter.dart';
import 'highlighters/web_highlighter.dart';


class SyntaxHighlighter {
  static TextSpan highlightCode(String code, String language) {
    switch (language.toLowerCase()) {
      case 'c#':
        return CSharpHighlighter.highlightCSharp(code);
      case 'kotlin':
        return KotlinHighlighter.highlightKotlin(code);
      case 'typescript':
        return TypeScriptHighlighter.highlightTypeScript(code);
      case 'swift':
        return SwiftHighlighter.highlightSwift(code);
      case 'bash':
        return BashHighlighter.highlightBash(code);
      case 'dart':
        return DartHighlighter.highlightDart(code);
      case 'web':
        return WebHighlighter.highlightWeb(code);
      default:
        return GenericHighlighter.highlightGeneric(code);
    }
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
      return 'web';
    } else {
      return 'generic';
    }
  }
}