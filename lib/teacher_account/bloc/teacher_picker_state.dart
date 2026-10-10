part of 'teacher_picker_bloc.dart';

@freezed
abstract class TeacherPickerState with _$TeacherPickerState {
  const factory TeacherPickerState({
    @Default('') String query,
    Teacher? selected,
    @Default(TeacherResource<List<Teacher>>.idle())
    TeacherResource<List<Teacher>> results,
    @Default(<String>{}) Set<String> ambiguousNames,
  }) = _TeacherPickerState;

  const TeacherPickerState._();

  List<Teacher> get teachers => results.data ?? const [];

  List<Teacher> get visibleTeachers => [
    for (final teacher in teachers)
      if (teacher.pickerKey != selected?.pickerKey) teacher,
  ];

  bool isAmbiguous(Teacher teacher) =>
      ambiguousNames.contains(teacher.pickerName);
}

extension TeacherPickerIdentity on Teacher {
  String get pickerName => name.trim().toLowerCase();

  String get pickerKey =>
      isPickerLinkable ? 'id:${uid!.trim()}' : 'name:$pickerName';

  bool get isPickerLinkable => uid?.trim().isNotEmpty == true;
}
