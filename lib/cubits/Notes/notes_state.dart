class NotesState {
  final String notesContent;
  final bool isLoading;

  NotesState({
    this.notesContent = '',
    this.isLoading = true,
  });

  NotesState copyWith({
    String? notesContent,
    bool? isLoading
  }) {
    return NotesState(
      notesContent: notesContent ?? this.notesContent,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}