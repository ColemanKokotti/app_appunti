import '../models/subject.dart';

class SubjectData {
  static List<Subject> getSubjects() {
    return [
      Subject(
        name: 'API',
        iconName: 'api',
        assetPath: 'assets/Schema_API.txt',
      ),
      Subject(
        name: 'Copyright',
        iconName: 'copyright',
        assetPath: 'assets/Schema_Copyright.txt',
      ),

    ];
  }
}