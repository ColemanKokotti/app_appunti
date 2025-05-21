import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/Notes/notes_cubit.dart';
import '../cubits/Subject/subject_state.dart'; // Assicurati che il percorso sia corretto
import '../cubits/Subject/subjects_cubit.dart';
import '../models/subject.dart';
import '../screens/notes_page.dart';
import '../utils/icon_mapper.dart';
import '../themes/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.primaryColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Naviga alla pagina delle note, fornendo il NotesCubit
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => NotesCubit(subject: subject),
                child: NotesPage(subject: subject),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.primaryColor,
        highlightColor: AppTheme.primaryColor,
        child: Stack( // Lo Stack ci permette di sovrapporre gli elementi
          children: [
            // Questo è il CONTENUTO PRINCIPALE (icona e testo).
            // Usiamo Positioned.fill per assicurarci che occupi tutto lo spazio dello Stack.
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.cardColor,
                      AppTheme.cardColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente Icona e Testo
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: IconMapper.getIconWidget(subject.iconName, size: 48),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                      textAlign: TextAlign.center, // Centra orizzontalmente il testo
                    ),
                  ],
                ),
              ),
            ),

            // Questo è il BlocBuilder e il Positioned per la CHECKBOX.
            // Sarà posizionato sopra il contenuto principale.
            BlocBuilder<SubjectSelectionCubit, SubjectSelectionState>(
              builder: (context, state) {
                return Positioned(
                  top: 8,   // Distanza dal bordo superiore della card
                  right: 8, // Distanza dal bordo destro della card
                  child: Transform.scale(
                    scale: 1.2, // Mantiene l'aspetto rotondo e un po' più grande
                    child: Checkbox(
                      value: state.isSelected,
                      onChanged: (bool? newValue) {
                        context.read<SubjectSelectionCubit>().toggleSelection();
                      },
                      shape: const CircleBorder(), // Rende la checkbox rotonda
                      activeColor: AppTheme.primaryColor,
                      checkColor: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}