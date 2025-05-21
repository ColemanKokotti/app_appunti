import 'package:flutter/material.dart';
import '../../utils/syntax_highlighter.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String? subjectName;
  final String? fileName;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.subjectName,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    // Determine language based on file name if available, otherwise use subject
    String language;
    String languageLabel;

    if (fileName != null) {
      // Use the new function to identify language from filename
      language = SyntaxHighlighter.identifyLanguageFromFilename(fileName!);
      languageLabel = _getDisplayLanguageLabel(language);
    } else if (subjectName != null) {
      // This is kept for backward compatibility
      language = _mapSubjectToLanguage(subjectName!);
      languageLabel = _getDisplayLanguageLabel(language);
    } else {
      language = 'generic';
      languageLabel = 'Code';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background for code (VS Code dark theme)
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFF3A3F58), width: 1),
      ),
      child: Stack(
        children: [
          // Code content with syntax highlighting
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: SyntaxHighlighter.highlightCode(code, language),
              softWrap: false,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              maxLines: null,
              overflow: TextOverflow.clip,
              textScaler: MediaQuery.textScalerOf(context),
              strutStyle: const StrutStyle(
                fontFamily: 'Consolas, Monaco, "Courier New", monospace',
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ),

          // Language label
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: const BoxDecoration(
                color: Color(0xFF38354A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  topRight: Radius.circular(7.0),
                ),
              ),
              child: Text(
                languageLabel,
                style: const TextStyle(
                  color: Color(0xFFB180ED),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to map subject name to language
  String _mapSubjectToLanguage(String subject) {
    // Legacy mapping logic, can be integrated into SyntaxHighlighter if needed
    if (subject.contains('Programming Fundamentals')) {
      return 'c#';
    } else if (subject.contains('Android')) {
      return 'kotlin';
    } else if (subject.contains('React')) {
      return 'typescript';
    } else if (subject.contains('IOS')) {
      return 'swift';
    } else if (subject.contains('Linux')) {
      return 'bash';
    } else if (subject.contains('Flutter')) {
      return 'dart';
    } else if (subject.contains('Web')) {
      return 'html/css/javascript';
    } else {
      return 'generic';
    }
  }

  // Helper method to get a nice display label for the language
  String _getDisplayLanguageLabel(String language) {
    switch (language.toLowerCase()) {
      case 'c#':
        return 'C#';
      case 'kotlin':
        return 'Kotlin';
      case 'typescript':
        return 'TypeScript';
      case 'swift':
        return 'Swift';
      case 'bash':
        return 'Bash';
      case 'dart':
        return 'Dart';
      case 'html/css/javascript':
        return 'HTML/CSS/JS';
      default:
        return 'Code';
    }
  }
}
