import 'package:flutter/material.dart';
import '../data/subject_data.dart';
import '../models/subject.dart';
import '../widgets/subject_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = SubjectData.getSubjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schemi Studio Esame ITS'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return SubjectCard(subject: subject);
            },
          ),
        ),
      ),
    );
  }
}