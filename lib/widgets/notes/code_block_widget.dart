import 'package:flutter/material.dart';
import '../../utils/syntax_highlighter.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;

  const CodeBlockWidget({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Colore di sfondo scuro per il codice (VS Code dark theme)
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFF3A3F58), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Contenuto del codice con evidenziazione sintassi
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: SyntaxHighlighter.highlightCSharp(code),
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
              child: const Text(
                'C#',
                style: TextStyle(
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
}