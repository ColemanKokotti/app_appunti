import 'package:flutter/material.dart';

abstract class BaseFormatter {
  static bool isNewParagraphStart(String line) {
    return line.startsWith('I.') || line.startsWith('II.') ||
        line.startsWith('III.') || line.startsWith('IV.') ||
        line.startsWith('V.') || line.startsWith('VI.') ||
        line.startsWith('VII.') || line.startsWith('VIII.') ||
        line.startsWith('IX.') || line.startsWith('X.') ||
        line.startsWith('XI.') || line.startsWith('XII.');
  }

  static bool isCodeBlockStart(String trimmedLine) {
    return trimmedLine.startsWith('```') ||
        trimmedLine == 'C#' ||
        trimmedLine.startsWith('int[') ||
        trimmedLine.startsWith('int ') ||
        trimmedLine.startsWith('double ') ||
        trimmedLine.startsWith('string ') ||
        trimmedLine.startsWith('bool ') ||
        trimmedLine.startsWith('List<') ||
        trimmedLine.startsWith('Stack<') ||
        trimmedLine.startsWith('Queue<') ||
        trimmedLine.startsWith('Dictionary<') ||
        trimmedLine.startsWith('HashSet<') ||
        trimmedLine.startsWith('class ') ||
        trimmedLine.startsWith('interface ') ||
        trimmedLine.startsWith('abstract class ') ||
        trimmedLine.startsWith('void ') ||
        trimmedLine.startsWith('static ') ||
        trimmedLine.startsWith('public ') ||
        trimmedLine.startsWith('private ') ||
        trimmedLine.startsWith('protected ') ||
        trimmedLine.startsWith('for (') ||
        trimmedLine.startsWith('while (') ||
        trimmedLine.startsWith('switch (') ||
        trimmedLine.startsWith('if (') ||
        trimmedLine.startsWith('else ') ||
        trimmedLine.contains(' => ') ||
        trimmedLine == 'do' ||
        (trimmedLine.startsWith('using ') && trimmedLine.contains('('));
  }
}