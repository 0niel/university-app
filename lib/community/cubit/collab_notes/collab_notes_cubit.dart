import 'dart:async';

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
  StreamSubscription<void>? _watchSubscription;
  Timer? _watchDebounce;

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

  void startWatching() {
    if (_watchSubscription != null) return;
    _watchSubscription = _repository.watchGroupNotesList().listen(
      (_) {
        _watchDebounce?.cancel();
        _watchDebounce = Timer(
          const Duration(milliseconds: 600),
          () => unawaited(load()),
        );
      },
      onError: addError,
    );
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

  Future<bool> rename(String id, String title) async {
    final normalized = title.trim();
    if (normalized.isEmpty) return false;
    final previous = state.notes;
    final index = previous.indexWhere((note) => note.id == id);
    if (index < 0) return false;
    final updated = List<CollabNote>.of(previous);
    updated[index] = updated[index].copyWith(title: normalized);
    emit(state.copyWith(notes: updated));
    try {
      await _repository.renameGroupNote(id, normalized);
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(notes: previous));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> setVisibility(String id, CollabNoteVisibility visibility) async {
    final previous = state.notes;
    final index = previous.indexWhere((note) => note.id == id);
    if (index < 0) return false;
    final updated = List<CollabNote>.of(previous);
    updated[index] = updated[index].copyWith(
      isPersonal: visibility == .personal,
    );
    emit(state.copyWith(notes: updated));
    try {
      await _repository.setGroupNoteVisibility(id, visibility);
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(notes: previous));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> delete(String id) async {
    final previous = state.notes;
    final updated = previous.where((note) => note.id != id).toList();
    if (updated.length == previous.length) return false;
    emit(state.copyWith(notes: updated));
    try {
      await _repository.deleteGroupNote(id);
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(notes: previous));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;

  @override
  Future<void> close() async {
    _watchDebounce?.cancel();
    await _watchSubscription?.cancel();
    return super.close();
  }
}
