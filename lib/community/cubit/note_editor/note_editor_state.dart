part of 'note_editor_cubit.dart';

@freezed
abstract class NoteEditorState with _$NoteEditorState {
  const factory NoteEditorState({
    required String title,
    required String content,
    DateTime? savedAt,
    @Default(NoteEditorStatus.clean) NoteEditorStatus status,
    @Default(<String>[]) List<String> editors,
    @Default(0) int revision,
    @Default(0) int persistedRevision,
    @Default(0) int serverRevision,
    @Default(false) bool canDelete,
    @Default(false) bool isDeleting,
  }) = _NoteEditorState;

  const NoteEditorState._();

  bool get hasUnsavedChanges => revision != persistedRevision;
}
