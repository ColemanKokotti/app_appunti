class SyntaxHighlighter {
  static String identifyLanguageFromFilename(String filename) {
    if (filename.toLowerCase().contains('csharp') || filename.toLowerCase().contains('c#')) {
      return 'csharp';
    } else if (filename.toLowerCase().contains('kotlin')) {
      return 'kotlin';
    } else if (filename.toLowerCase().contains('typescript')) {
      return 'typescript';
    } else if (filename.toLowerCase().contains('swift')) {
      return 'swift';
    } else if (filename.toLowerCase().contains('bash')) {
      return 'bash';
    } else if (filename.toLowerCase().contains('dart')) {
      return 'dart';
    } else if (filename.toLowerCase().contains('html') || filename.toLowerCase().contains('css') || filename.toLowerCase().contains('javascript') || filename.toLowerCase().contains('web')) {
      return 'html';
    } else if (filename.toLowerCase().contains('xml')) {
      return 'xml';
    }
    return 'plaintext';
  }
}