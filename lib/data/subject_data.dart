import '../models/subject.dart';

class SubjectData {
  static List<Subject> getSubjects() {
    return [
      Subject(
        name: 'API',
        iconName: 'api',
        assetPath: 'assets/txt/Schema_API.txt',
      ),
      Subject(
        name: 'Copyright',
        iconName: 'copyright',
        assetPath: 'assets/txt/Schema_Copyright.txt',
      ),
      Subject(
        name: 'Flutter',
        iconName: 'flutter',
        assetPath: 'assets/txt/Schema_Flutter.txt',
      ),
      Subject(
        name: 'IOS',
        iconName: 'ios',
        assetPath: 'assets/txt/Schema_IOS.txt',
      ),
      Subject(
        name: 'React Native',
        iconName: 'react',
        assetPath: 'assets/txt/Schema_React.txt',
      ),
      Subject(
        name: 'Android',
        iconName: 'android',
        assetPath: 'assets/txt/Schema_Android.txt',
      ),
      Subject(
        name: 'Database',
        iconName: 'database',
        assetPath: 'assets/txt/Schema_Database.txt',
      ),
      Subject(
        name: 'Web',
        iconName: 'web',
        assetPath: 'assets/txt/Schema_Web.txt',
      ),
      Subject(
        name: 'App Architecture',
        iconName: 'app_architecture',
        assetPath: 'assets/txt/Schema_App_Architecture.txt',
      ),
      Subject(
        name: 'Programming Fundamentals',
        iconName: 'programming_fundamentals',
        assetPath: 'assets/txt/Schema_Programming_Fundamentals.txt',
      ),
      Subject(
        name: 'Ux Ui',
        iconName: 'ux_ui',
        assetPath: 'assets/txt/Schema_Ux_Ui.txt',
      ),
      Subject(
        name: 'Linux',
        iconName: 'linux',
        assetPath: 'assets/txt/Schema_Linux.txt',
      ),
      Subject(
        name: 'Cybersecurity',
        iconName: 'cybersecurity',
        assetPath: 'assets/txt/Schema_Cybersecurity.txt',
      ),
      Subject(
          name: 'Version Control',
          iconName: 'git',
          assetPath: 'assets/txt/Schema_Version_Control.txt'
      )
    ];
  }
}