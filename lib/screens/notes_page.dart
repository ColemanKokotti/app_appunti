import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/Notes/notes_cubit.dart';
import '../cubits/Notes/notes_state.dart';
import '../models/subject.dart';
import '../themes/app_theme.dart';
import '../widgets/notes/notes_content_viewer.dart';

class NotesPage extends StatelessWidget {
  final Subject subject;

  const NotesPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit(subject: subject)),
      ],
      child: _NotesPageContent(subject: subject),
    );
  }
}

class _NotesPageContent extends StatelessWidget {
  final Subject subject;

  const _NotesPageContent({required this.subject});

  @override
  Widget build(BuildContext context) {
    context.read<NotesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Appunti di ${subject.name}'),
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ));
            }

            return Stack(
              children: [
                   Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: NotesContentViewer(
                        notesContent: state.notesContent,
                        subject: subject.name,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}