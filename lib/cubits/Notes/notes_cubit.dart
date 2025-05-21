


import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/subject.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final Subject subject;

  NotesCubit({required this.subject}) : super(NotesState()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final content = await rootBundle.loadString(subject.assetPath);
      emit(state.copyWith(
        notesContent: content,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        notesContent: 'Errore nel caricamento degli appunti: $e',
        isLoading: false,
      ));
    }
  }

  void toggleMagnifier() {
    emit(state.copyWith(
      showMagnifier: !state.showMagnifier,
    ));
  }

  void adjustZoomLevel(double change) {
    final newZoomLevel = (state.zoomLevel + change).clamp(1.2, 3.0);
    emit(state.copyWith(
      zoomLevel: newZoomLevel,
    ));
  }
}