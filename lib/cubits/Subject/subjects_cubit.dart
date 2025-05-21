import 'package:appunti/cubits/Subject/subject_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  SubjectSelectionCubit({bool initialSelected = false})
      : super(SubjectSelectionState(isSelected: initialSelected));

  void toggleSelection() {
    emit(state.copyWith(isSelected: !state.isSelected));
  }
}