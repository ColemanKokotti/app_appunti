import 'package:flutter/material.dart';

class AppTheme {
  // Colori principali del tema
  static const Color primaryColor = Color(0xFF00897B); // Teal più scuro
  static const Color accentColor = Color(0xFF4DB6AC);  // Teal più chiaro
  static const Color backgroundColor = Color(0xFF6C4675); // Sfondo scuro
  static const Color surfaceColor = Color(0xFF1E1E1E);  // Superficie elementi scura
  static const Color cardColor = Color(0xFF2C2C2C);     // Colore card più scuro
  static const Color iconColor = Colors.white;

  // Colori testo
  static const Color textPrimaryColor = Color(0xFFFFFFFF);   // Testo principale bianco
  static const Color textSecondaryColor = Color(0xFFB0B0B0); // Testo secondario grigio chiaro

  // Colori paragrafi
  static const Color headingColor = Color(0xFF4DB6AC);  // Colore intestazioni (teal chiaro)
  static const Color subheadingColor = Color(0xFF26A69A); // Colore sottointestazioni
  // Nuovi colori per il blocco di codice
  static const Color codeBlockBackground = Color(0xFF1E1E1E); // Sfondo scuro per il codice (VS Code dark theme)
  static const Color codeBlockBorder = Color(0xFF3A3A3A);    // Bordo leggero
  static const Color codeBlockHeader = Color(0xFF282828);    // Sfondo per l'header del blocco di codice
  static const Color codeBlockFooter = Color(0xFF282828);    // Sfondo per il footer del blocco di codice
  static const Color codeBlockFooterText = Color(0xFFB180ED); // Colore del testo nel footer

  // Tema per l'evidenziazione della sintassi (esempio, puoi personalizzarlo)
  // Questi stili sovrascriveranno i valori predefiniti del tema di highlight
  static Map<String, TextStyle> codeTheme = {
    'root': const TextStyle(
      backgroundColor: codeBlockBackground,
      color: Color(0xFFD4D4D4), // Colore del testo generale del codice
    ),
    'keyword': const TextStyle(color: Color(0xFF569CD6)), // Esempio: parole chiave blu
    'built_in': const TextStyle(color: Color(0xFF569CD6)),
    'type': const TextStyle(color: Color(0xFF569CD6)),
    'literal': const TextStyle(color: Color(0xFF569CD6)),
    'number': const TextStyle(color: Color(0xFFB5CEA8)), // Esempio: numeri verdi
    'string': const TextStyle(color: Color(0xFFD69D85)), // Esempio: stringhe arancioni
    'comment': const TextStyle(color: Color(0xFF6A9955)), // Esempio: commenti verdi scuri
    'variable': const TextStyle(color: Color(0xFF9CDCFE)),
    'function': const TextStyle(color: Color(0xFFDCDCAA)),
    'title': const TextStyle(color: Color(0xFFDCDCAA)),
    'params': const TextStyle(color: Color(0xFF9CDCFE)),
    'operator': const TextStyle(color: Color(0xFFD4D4D4)),
    'selector-tag': const TextStyle(color: Color(0xFF569CD6)),
    'tag': const TextStyle(color: Color(0xFF569CD6)),
    'name': const TextStyle(color: Color(0xFFC586C0)),
    'attr': const TextStyle(color: Color(0xFF9CDCFE)),
    'attribute': const TextStyle(color: Color(0xFF9CDCFE)),
    'class': const TextStyle(color: Color(0xFF4EC9B0)),
    'regexp': const TextStyle(color: Color(0xFFD16969)),
    'link': const TextStyle(color: Color(0xFF9CDCFE), decoration: TextDecoration.underline),
    'meta': const TextStyle(color: Color(0xFF9CDCFE)),
    'emphasis': const TextStyle(fontStyle: FontStyle.italic),
    'strong': const TextStyle(fontWeight: FontWeight.bold),
  };
  // Tema scuro dell'applicazione
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    canvasColor: backgroundColor,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardTheme(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textPrimaryColor),
      titleSmall: TextStyle(color: textPrimaryColor),
      bodyLarge: TextStyle(color: textPrimaryColor),
      bodyMedium: TextStyle(color: textPrimaryColor),
      bodySmall: TextStyle(color: textSecondaryColor),
      labelLarge: TextStyle(color: textPrimaryColor),
      labelMedium: TextStyle(color: textPrimaryColor),
      labelSmall: TextStyle(color: textSecondaryColor),
    ),

    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
  );
}