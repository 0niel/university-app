import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor_status.dart';

part 'note_editor_cubit.freezed.dart';
part 'note_editor_state.dart';

class NoteEditorCubit extends Cubit<NoteEditorState> {
  factory NoteEditorCubit({
    required CampusRepository repository,
    required CollabNote note,
    required String editorName,
    Duration saveDebounce = const Duration(milliseconds: 1200),
  }) => NoteEditorCubit._(repository, note, editorName, saveDebounce);

  NoteEditorCubit._(
    this._repository,
    CollabNote note,
    String editorName,
    this._saveDebounce,
  ) : _noteId = note.id,
      super(
        NoteEditorState(
          title: note.title,
          content: note.content,
          savedAt: note.updatedAt,
          serverRevision: note.revision,
          canDelete: note.isMine,
        ),
      ) {
    if (!note.isPersonal) _openPresence(editorName);
  }

  final CampusRepository _repository;
  final String _noteId;
  final Duration _saveDebounce;
  Timer? _debounce;
  Future<bool>? _saveTask;
  CollabNotePresenceSession? _presence;
  StreamSubscription<List<String>>? _presenceSubscription;
  var _deleteRequested = false;

  void titleChanged(String title) => _draftChanged(title: title);

  void contentChanged(String content) => _draftChanged(content: content);

  void _draftChanged({String? title, String? content}) {
    if (_deleteRequested || isClosed) return;
    emit(
      state.copyWith(
        title: title ?? state.title,
        content: content ?? state.content,
        revision: state.revision + 1,
        status: .dirty,
      ),
    );
    _debounce?.cancel();
    _debounce = Timer(_saveDebounce, () => unawaited(flush()));
  }

  Future<bool> flush() {
    _debounce?.cancel();
    _debounce = null;
    if (_deleteRequested || state.status == .deleted) {
      return Future.value(false);
    }
    final active = _saveTask;
    if (active != null) return active;
    final task = _saveLatest();
    _saveTask = task;
    return task.whenComplete(() => _saveTask = null);
  }

  Future<bool> _saveLatest() async {
    if (state.revision == state.persistedRevision) return true;
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(status: .failure));
      return false;
    }
    while (!_deleteRequested && !isClosed) {
      final revision = state.revision;
      final title = state.title.trim();
      final content = state.content;
      emit(state.copyWith(status: .saving));
      try {
        final result = await _repository.saveGroupNote(
          id: _noteId,
          title: title,
          content: content,
          expectedRevision: state.serverRevision,
        );
        if (isClosed) return false;
        final hasNewDraft = state.revision > revision;
        emit(
          state.copyWith(
            persistedRevision: revision,
            serverRevision: result.revision,
            savedAt: result.updatedAt,
            status: hasNewDraft ? .dirty : .saved,
          ),
        );
        if (_deleteRequested) return false;
        if (!hasNewDraft) return true;
        continue;
      } on CollabNoteConflictException catch (error, stackTrace) {
        if (!isClosed && !_deleteRequested) {
          emit(state.copyWith(status: .conflict));
          addError(error, stackTrace);
        }
        return false;
      } on Exception catch (error, stackTrace) {
        if (!isClosed && !_deleteRequested) {
          emit(state.copyWith(status: .failure));
          addError(error, stackTrace);
        }
        return false;
      }
    }
    return false;
  }

  Future<bool> delete() async {
    if (!state.canDelete || _deleteRequested) return false;
    _deleteRequested = true;
    _debounce?.cancel();
    _debounce = null;
    final active = _saveTask;
    if (active != null) await active;
    if (isClosed) return false;
    emit(state.copyWith(isDeleting: true));
    try {
      await _repository.deleteGroupNote(_noteId);
      if (isClosed) return false;
      emit(state.copyWith(isDeleting: false, status: .deleted));
      return true;
    } on Exception catch (error, stackTrace) {
      _deleteRequested = false;
      if (!isClosed) {
        emit(state.copyWith(isDeleting: false, status: .failure));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  void discardChanges() {
    _debounce?.cancel();
    _debounce = null;
    if (!isClosed) {
      emit(
        state.copyWith(
          persistedRevision: state.revision,
          status: .clean,
        ),
      );
    }
  }

  void _openPresence(String editorName) {
    final presence = _repository.openGroupNotePresence(
      noteId: _noteId,
      editorName: editorName,
    );
    _presence = presence;
    _presenceSubscription = presence.editors.listen(
      (editors) {
        if (!isClosed) emit(state.copyWith(editors: editors));
      },
      onError: addError,
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    if (!_deleteRequested && state.hasUnsavedChanges) await flush();
    await _presenceSubscription?.cancel();
    await _presence?.close();
    return super.close();
  }
}
