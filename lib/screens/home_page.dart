import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/Subject/subjects_cubit.dart';
import '../data/subject_data.dart';
import '../models/subject.dart';
import '../widgets/subject_card.dart';
import '../themes/app_theme.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = SubjectData.getSubjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schemi Studio Esame ITS'),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                ),
                Expanded(
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
                      return BlocProvider(
                        create: (context) => SubjectSelectionCubit(),
                        child: SubjectCard(subject: subject),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}