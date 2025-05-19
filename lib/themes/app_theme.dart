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