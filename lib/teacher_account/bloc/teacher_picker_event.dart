part of 'teacher_picker_bloc.dart';

@freezed
sealed class TeacherPickerEvent with _$TeacherPickerEvent {
  const factory TeacherPickerEvent.searchRequested({
    required String query,
    @Default(false) bool immediate,
  }) = TeacherPickerSearchRequested;

  const factory TeacherPickerEvent.selectionChanged(Teacher? teacher) =
      TeacherPickerSelectionChanged;

  const factory TeacherPickerEvent.teacherSelected(Teacher teacher) =
      TeacherPickerTeacherSelected;
}
