part of 'note_editor_cubit.dart';

@freezed
abstract class NoteEditorState with _$NoteEditorState {
  const factory NoteEditorState({
    required String title,
    DateTime? savedAt,
    @Default(NoteEditorStatus.clean) NoteEditorStatus status,
    @Default(<String>[]) List<String> editors,
    @Default(0) int revision,
    @Default(0) int persistedRevision,
    @Default(false) bool canDelete,
    @Default(false) bool isDeleting,
    @Default(false) bool readOnly,
    @Default(NoteVoiceStatus.idle) NoteVoiceStatus voiceStatus,
  }) = _NoteEditorState;

  const NoteEditorState._();

  bool get canRename => canDelete && !readOnly;

  bool get hasUnsavedChanges =>
      revision != persistedRevision ||
      switch (status) {
        .dirty || .saving || .failure || .offline || .conflict => true,
        _ => false,
      };
}
