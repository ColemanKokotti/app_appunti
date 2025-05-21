class LanguageMapper {
  static String getLanguageForSubject(String subjectName) {
    switch (subjectName) {
      case 'Programming Fundamentals':
        return 'csharp'; // Usiamo 'csharp' come nome del linguaggio per highlight
      case 'Android':
        return 'kotlin';
      case 'React Native':
        return 'typescript';
      case 'IOS':
        return 'swift';
      case 'Linux':
        return 'bash';
      case 'Flutter':
        return 'dart';
      case 'Web':
        return 'html'; // 'html' è un buon fallback per web (include js/css)
      case 'XML':
        return 'xml';
      case 'Compose':
        return 'kotlin'; // Compose è Kotlin
      default:
        return 'plaintext'; // Default per linguaggi non riconosciuti
    }
  }
}