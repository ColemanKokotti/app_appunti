import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:equatable/equatable.dart'; // Aggiungi equatable nel pubspec.yaml se non l'hai già


class CodeBlockState extends Equatable {
  final CodeController controller;
  final String languageLabel;

  const CodeBlockState({
    required this.controller,
    required this.languageLabel,
  });

  @override
  List<Object?> get props => [controller, languageLabel];
}
