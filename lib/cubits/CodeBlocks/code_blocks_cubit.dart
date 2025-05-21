import 'package:bloc/bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/all.dart';
import '../../utils/language_mapper.dart';
import '../../utils/syntax_highlighter.dart';
import 'code_blocks_state.dart';

class CodeBlockCubit extends Cubit<CodeBlockState> {
  CodeBlockCubit({
    required String code,
    String? subjectName,
    String? fileName,
  }) : super(CodeBlockState(
    controller: CodeController(text: ''),
    languageLabel: 'Code',
  )) {
    _initializeController(code, subjectName, fileName);
  }

  void _initializeController(String code, String? subjectName, String? fileName) {
    String languageName;
    String languageLabel;

    if (fileName != null) {
      languageName = SyntaxHighlighter.identifyLanguageFromFilename(fileName);
      languageLabel = _getDisplayLanguageLabel(languageName);
    } else if (subjectName != null) {
      languageName = LanguageMapper.getLanguageForSubject(subjectName);
      languageLabel = _getDisplayLanguageLabel(languageName);
    } else {
      languageName = 'plaintext'; // Default
      languageLabel = 'Code';
    }

    final language = allLanguages[languageName];

    final newController = CodeController(
      text: code,
      language: language,
    );

    emit(CodeBlockState(
      controller: newController,
      languageLabel: languageLabel,
    ));
  }

  String _getDisplayLanguageLabel(String language) {
    switch (language.toLowerCase()) {
      case 'csharp':
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
      case 'html':
        return 'HTML/CSS/JavaScript';
      case 'xml':
        return 'XML';
      case 'plaintext':
        return 'Text';
      default:
        return 'Code';
    }
  }

  @override
  Future<void> close() {
    state.controller.dispose(); // Dispone il controller quando il Cubit viene chiuso
    return super.close();
  }
}