import 'package:flutter/material.dart';
import '../../widgets/notes/code_block_widget.dart';

class CodeBlockFormatter {
  static bool isInCodeBlock = false;
  static StringBuffer codeBuffer = StringBuffer();
  static String? subjectName;

  static void reset() {
    isInCodeBlock = false;
    codeBuffer.clear();
  }

  static void setSubjectName(String name) {
    subjectName = name;
  }

  static void appendLine(String line) {
    codeBuffer.writeln(line);
  }

  static Widget buildCodeBlockWidget() {
    Widget widget = CodeBlockWidget(
      code: codeBuffer.toString().trim(),
      subjectName: subjectName,
    );
    codeBuffer.clear();
    return widget;
  }

  static bool shouldCloseBlock(List<String> lines, int currentIndex) {
    // If it's the last line
    if (currentIndex == lines.length - 1) {
      return true;
    }

    // If the next line is empty or a new paragraph
    if (currentIndex + 1 < lines.length) {
      String nextLine = lines[currentIndex + 1].trim();
      return nextLine.isEmpty || nextLine.startsWith('```');
    }

    return false;
  }
}