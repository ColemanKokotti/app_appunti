import '../models/subject.dart';

class SubjectData {
  static List<Subject> getSubjects() {
    return [
      Subject(
        name: 'Schema API',
        iconName: 'api',
        assetPath: 'assets/Schema_API.txt',
      ),
      Subject(
        name: 'Schema Copyright',
        iconName: 'copyright',
        assetPath: 'assets/Schema_Copyright.txt',
      ),

    ];
  }
}