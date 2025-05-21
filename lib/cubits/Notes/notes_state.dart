class NotesState {
  final String notesContent;
  final bool isLoading;
  final bool showMagnifier;
  final double zoomLevel;

  NotesState({
    this.notesContent = '',
    this.isLoading = true,
    this.showMagnifier = false,
    this.zoomLevel = 1.5,
  });

  NotesState copyWith({
    String? notesContent,
    bool? isLoading,
    bool? showMagnifier,
    double? zoomLevel,
  }) {
    return NotesState(
      notesContent: notesContent ?? this.notesContent,
      isLoading: isLoading ?? this.isLoading,
      showMagnifier: showMagnifier ?? this.showMagnifier,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }
}