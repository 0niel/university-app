part of 'collab_notes_cubit.dart';

@freezed
abstract class CollabNotesState with _$CollabNotesState {
  const factory CollabNotesState({
    @Default(CollabNotesStatus.initial) CollabNotesStatus status,
    @Default(<CollabNote>[]) List<CollabNote> notes,
    @Default(false) bool isCreating,
  }) = _CollabNotesState;
}
