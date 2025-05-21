class LanguageMapper {
  static String getLanguageForSubject(String subjectName) {
    switch (subjectName) {
      case 'Programming Fundamentals':
        return 'C#';
      case 'Android':
        return 'Kotlin';
      case 'React Native':
        return 'TypeScript';
      case 'IOS':
        return 'Swift';
      case 'Linux':
        return 'Bash';
      case 'Flutter':
        return 'Dart';
      case 'Web':
        return 'HTML/CSS/JavaScript';
    // Default case for other subjects
      default:
        return 'Code';
    }
  }
}