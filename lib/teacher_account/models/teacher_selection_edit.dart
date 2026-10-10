import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_selection_edit.freezed.dart';

@freezed
sealed class TeacherSelectionEdit with _$TeacherSelectionEdit {
  const factory TeacherSelectionEdit.keep() = TeacherSelectionKeep;

  const factory TeacherSelectionEdit.select(Teacher teacher) =
      TeacherSelectionSelect;

  const factory TeacherSelectionEdit.clear() = TeacherSelectionClear;
}
