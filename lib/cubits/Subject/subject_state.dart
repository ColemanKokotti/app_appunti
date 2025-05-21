class SubjectSelectionState {
  final bool isSelected;

  const SubjectSelectionState({this.isSelected = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is SubjectSelectionState &&
              runtimeType == other.runtimeType &&
              isSelected == other.isSelected);

  @override
  int get hashCode => isSelected.hashCode;

  SubjectSelectionState copyWith({
    bool? isSelected,
  }) {
    return SubjectSelectionState(
      isSelected: isSelected ?? this.isSelected,
    );
  }
}