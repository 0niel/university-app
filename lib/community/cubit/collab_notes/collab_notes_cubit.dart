import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes_status.dart';

part 'collab_notes_cubit.freezed.dart';
part 'collab_notes_state.dart';

class CollabNotesCubit extends Cubit<CollabNotesState> {
  factory CollabNotesCubit({required CampusRepository repository}) =>
      CollabNotesCubit._(repository);

  CollabNotesCubit._(this._repository) : super(const CollabNotesState());

  final CampusRepository _repository;
  var _loadRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final notes = await _repository.getGroupNotes();
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .ready, notes: notes));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<CollabNote?> create({
    required String title,
    required CollabNoteVisibility visibility,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty || state.isCreating) return null;
    emit(state.copyWith(isCreating: true));
    try {
      final id = await _repository.createGroupNote(
        normalizedTitle,
        visibility: visibility,
      );
      if (isClosed) return null;
      final now = DateTime.now();
      final note = CollabNote(
        id: id,
        title: normalizedTitle,
        isMine: true,
        isPersonal: visibility == .personal,
        createdAt: now,
        updatedAt: now,
      );
      emit(state.copyWith(isCreating: false, notes: [note, ...state.notes]));
      return note;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(isCreating: false));
        addError(error, stackTrace);
      }
      return null;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;
}
