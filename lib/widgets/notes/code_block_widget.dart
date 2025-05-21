import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import '../../cubits/CodeBlocks/code_blocks_cubit.dart';
import '../../cubits/CodeBlocks/code_blocks_state.dart';
import '../../themes/app_theme.dart';

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
    return BlocProvider(
      create: (context) => CodeBlockCubit(
        code: code,
        subjectName: subjectName,
        fileName: fileName,
      ),
      child: BlocBuilder<CodeBlockCubit, CodeBlockState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            decoration: BoxDecoration(
              color: AppTheme.codeBlockBackground,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppTheme.codeBlockBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: AppTheme.codeBlockHeader,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
                  ),
                  child: Text(
                    state.languageLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Fixed Code Display Area
                SizedBox(
                  height: 200, // Fixed height to avoid layout issues
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      // Ensure the code has a minimum width
                      width: MediaQuery.of(context).size.width - 40, // Subtract some padding
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: CodeTheme(
                          data: CodeThemeData(styles: AppTheme.codeTheme),
                          child: CodeField(
                            controller: state.controller,
                            textStyle: const TextStyle(fontFamily: 'monospace'),
                            readOnly: true,
                            padding: const EdgeInsets.all(8.0),
                            minLines: 3, // Minimum number of lines
                            expands: false, // Don't expand to fill available space
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: AppTheme.codeBlockFooter,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                    children: [
                      Flexible( // Use Flexible instead of Expanded
                        child: Text(
                          'Note: ${fileName ?? subjectName ?? 'Code Block'}',
                          style: const TextStyle(
                            color: AppTheme.codeBlockFooterText,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}