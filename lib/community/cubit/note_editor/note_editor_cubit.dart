import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_delta_rebase.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_document_text.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor_status.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

part 'note_editor_cubit.freezed.dart';
part 'note_editor_state.dart';

class NoteEditorCubit extends Cubit<NoteEditorState> {
  factory NoteEditorCubit({
    required CampusRepository repository,
    required CollabNote note,
    required String editorName,
    Duration saveDebounce = const Duration(milliseconds: 1500),
  }) {
    final delta = _initialDelta(note);
    return NoteEditorCubit._(repository, note, editorName, saveDebounce, delta);
  }

  NoteEditorCubit._(
    this._repository,
    CollabNote note,
    String editorName,
    this._saveDebounce,
    Delta initialDelta,
  ) : _noteId = note.id,
      _baseRevision = note.documentRevision,
      _syncedDelta = initialDelta,
      _syncedTitle = note.title,
      _clientId = const Uuid().v4(),
      controller = QuillController(
        document: Document.fromDelta(initialDelta),
        selection: const TextSelection.collapsed(offset: 0),
      ),
      super(
        NoteEditorState(
          title: note.title,
          savedAt: note.updatedAt,
          canDelete: note.isMine,
        ),
      ) {
    _documentSubscription = controller.document.changes.listen(
      _onDocumentChange,
    );
    if (!note.isPersonal) _openRealtime(editorName);
  }

  static Delta _initialDelta(CollabNote note) {
    final raw = note.document;
    if (raw != null && raw.isNotEmpty) {
      try {
        return _documentDelta(raw);
      } on Object {
        return deltaFromPlainText(note.content);
      }
    }
    return deltaFromPlainText(note.content);
  }

  static Delta _documentDelta(List<Object?> document) {
    if (document.isEmpty ||
        document.any(
          (operation) =>
              operation is! Map ||
              !operation.containsKey('insert') ||
              operation.containsKey('retain') ||
              operation.containsKey('delete'),
        )) {
      throw const FormatException('Invalid note document');
    }
    final last = (document.last! as Map)['insert'];
    if (last is! String || !last.endsWith('\n')) {
      throw const FormatException('Note document must end with a newline');
    }
    final delta = Delta.fromJson(document);
    Document.fromDelta(delta).close();
    return delta;
  }

  final QuillController controller;
  final CampusRepository _repository;
  final String _noteId;
  final String _clientId;
  final Duration _saveDebounce;
  final SpeechToText _speech = SpeechToText();

  Timer? _debounce;
  Timer? _titleDebounce;
  Future<bool>? _saveTask;
  Future<bool>? _titleSaveTask;
  Future<void>? _resyncTask;
  CollabNoteRealtimeSession? _realtime;
  StreamSubscription<List<String>>? _editorsSubscription;
  StreamSubscription<CollabNoteChange>? _changesSubscription;
  StreamSubscription<void>? _connectionsSubscription;
  StreamSubscription<DocChange>? _documentSubscription;
  Delta _syncedDelta;
  String _syncedTitle;
  int _baseRevision;
  int? _voiceAnchor;
  int _voicePreviewLength = 0;
  String _voiceMutedColorHex = '';
  var _deleteRequested = false;
  var _discardRequested = false;
  var _documentSaving = false;
  CollabNoteChange? _pendingRemote;
  NoteEditorStatus? _titleFailure;
  var _titleGeneration = 0;
  var _resyncAgain = false;

  bool get _hasTitleDraft => state.title.trim() != _syncedTitle.trim();

  NoteEditorStatus get _settledStatus {
    if (_hasTitleDraft) return _titleFailure ?? .dirty;
    if (state.revision != state.persistedRevision) return .dirty;
    return .saved;
  }

  void titleChanged(String title) {
    if (_deleteRequested || _discardRequested || isClosed || !state.canRename) {
      return;
    }
    _titleFailure = null;
    _titleGeneration++;
    emit(state.copyWith(title: title, status: .dirty));
    _titleDebounce?.cancel();
    _titleDebounce = Timer(
      const Duration(milliseconds: 900),
      () => unawaited(_saveTitle()),
    );
  }

  Future<bool> _saveTitle() {
    _titleDebounce?.cancel();
    _titleDebounce = null;
    final active = _titleSaveTask;
    if (active != null) return active;
    final task = _saveTitleLoop().whenComplete(() => _titleSaveTask = null);
    _titleSaveTask = task;
    return task;
  }

  Future<bool> _saveTitleLoop() async {
    while (_hasTitleDraft) {
      if (isClosed ||
          _deleteRequested ||
          _discardRequested ||
          !state.canRename) {
        return false;
      }
      final title = state.title.trim();
      try {
        if (title.isEmpty || title.length > 200) {
          throw const FormatException('Invalid note title');
        }
        emit(state.copyWith(status: .saving));
        await _repository.renameGroupNote(_noteId, title);
        _syncedTitle = title;
        _titleFailure = null;
        if (isClosed || _deleteRequested || _discardRequested) return false;
        emit(state.copyWith(status: _settledStatus));
      } on Exception catch (error, stackTrace) {
        if (isClosed || _deleteRequested || _discardRequested) return false;
        _titleFailure = _looksOffline(error) ? .offline : .failure;
        emit(state.copyWith(status: _titleFailure!));
        addError(error, stackTrace);
        return false;
      }
    }
    return !isClosed && !_deleteRequested && !_discardRequested;
  }

  void _onDocumentChange(DocChange change) {
    if (change.source != ChangeSource.local) return;
    if (isClosed || _deleteRequested || _discardRequested) return;
    emit(state.copyWith(revision: state.revision + 1, status: .dirty));
    _debounce?.cancel();
    _debounce = Timer(_saveDebounce, () => unawaited(flush()));
  }

  Future<void> _broadcastCommittedDocument(
    GroupNoteDocumentSaveResult result,
  ) async {
    final realtime = _realtime;
    if (realtime == null) return;
    try {
      await realtime.broadcastChange(
        CollabNoteChange(
          clientId: _clientId,
          revision: result.revision,
          document: result.document,
          updatedAt: result.updatedAt,
        ),
      );
    } on Exception {
      return;
    }
  }

  void _openRealtime(String editorName) {
    final session = _repository.openGroupNoteRealtime(
      noteId: _noteId,
      editorName: editorName,
    );
    _realtime = session;
    _editorsSubscription = session.editors.listen(
      (editors) {
        if (!isClosed) emit(state.copyWith(editors: editors));
      },
      onError: addError,
    );
    _changesSubscription = session.changes.listen(
      _applyRemoteChange,
      onError: addError,
    );
    _connectionsSubscription = session.connections.listen(
      (_) => unawaited(resynchronize()),
      onError: addError,
    );
    unawaited(resynchronize());
  }

  void _applyRemoteChange(CollabNoteChange change) {
    if (isClosed ||
        _deleteRequested ||
        _discardRequested ||
        change.clientId == _clientId ||
        change.revision <= _baseRevision) {
      return;
    }
    try {
      _documentDelta(change.document);
      if (_documentSaving) {
        if (_pendingRemote == null ||
            change.revision > _pendingRemote!.revision) {
          _pendingRemote = change;
        }
        return;
      }
      _applySnapshot(change.document, change.revision);
      emit(state.copyWith(savedAt: change.updatedAt ?? state.savedAt));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _drainRemote() {
    final change = _pendingRemote;
    _pendingRemote = null;
    if (change != null) _applyRemoteChange(change);
  }

  Future<void> resynchronize() {
    final active = _resyncTask;
    if (active != null) {
      _resyncAgain = true;
      return active;
    }
    final task = _resynchronizeLoop().whenComplete(() => _resyncTask = null);
    _resyncTask = task;
    return task;
  }

  Future<void> _resynchronizeLoop() async {
    do {
      _resyncAgain = false;
      await _resynchronize();
    } while (_resyncAgain &&
        !isClosed &&
        !_discardRequested &&
        !_deleteRequested);
  }

  Future<void> _resynchronize() async {
    if (isClosed || _deleteRequested || _discardRequested) return;
    try {
      final titleGeneration = _titleGeneration;
      final canUpdateTitle = !_hasTitleDraft && _titleSaveTask == null;
      final note = await _repository.getGroupNote(_noteId);
      if (isClosed || _deleteRequested || _discardRequested) return;
      if (note == null) {
        emit(state.copyWith(status: .readOnly, readOnly: true));
        return;
      }
      if (canUpdateTitle &&
          !_hasTitleDraft &&
          titleGeneration == _titleGeneration) {
        _syncedTitle = note.title;
        emit(state.copyWith(title: note.title));
      }
      _applyRemoteChange(
        CollabNoteChange(
          clientId: 'server',
          revision: note.documentRevision,
          document: _initialDelta(note).toJson(),
          updatedAt: note.updatedAt,
        ),
      );
      emit(
        state.copyWith(
          canDelete: note.isMine,
          readOnly: false,
          status: state.status == .readOnly ? _settledStatus : state.status,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (!isClosed && !_discardRequested && !_deleteRequested) {
        addError(error, stackTrace);
      }
    }
  }

  Future<bool> flush() async {
    _debounce?.cancel();
    _debounce = null;
    if (isClosed ||
        _deleteRequested ||
        _discardRequested ||
        state.status == .deleted) {
      return false;
    }
    while (true) {
      final titleTask = _saveTitle();
      final task = _saveTask ??= _saveDocumentLoop().whenComplete(
        () => _saveTask = null,
      );
      final results = await Future.wait([titleTask, task]);
      if (!results.every((saved) => saved)) return false;
      if (!_hasTitleDraft && state.revision == state.persistedRevision) {
        if (!isClosed && !state.readOnly) emit(state.copyWith(status: .saved));
        return true;
      }
    }
  }

  Future<bool> _saveDocumentLoop() async {
    if (state.revision == state.persistedRevision) return true;
    while (!_deleteRequested && !_discardRequested && !isClosed) {
      final revision = state.revision;
      final localDoc = controller.document.toDelta();
      emit(state.copyWith(status: .saving));
      try {
        _documentSaving = true;
        final result = await _repository.saveGroupNoteDocument(
          id: _noteId,
          document: localDoc.toJson(),
          expectedRevision: _baseRevision,
        );
        _documentSaving = false;
        if (isClosed || _discardRequested) return false;
        if (result.revision <= _baseRevision) {
          throw const FormatException('Note revision did not advance');
        }
        if (result.conflict) {
          emit(state.copyWith(status: .conflict));
          _applySnapshot(result.document, result.revision);
          _drainRemote();
          continue;
        }
        _syncedDelta = localDoc;
        _baseRevision = result.revision;
        final hasNewDraft = state.revision > revision;
        emit(
          state.copyWith(
            persistedRevision: revision,
            savedAt: result.updatedAt,
            status: hasNewDraft
                ? .dirty
                : (_hasTitleDraft ? (_titleFailure ?? .dirty) : .saved),
            readOnly: false,
          ),
        );
        _drainRemote();
        unawaited(_broadcastCommittedDocument(result));
        if (_deleteRequested) return false;
        if (!hasNewDraft) return true;
        continue;
      } on CollabNoteUnavailableException catch (error, stackTrace) {
        _documentSaving = false;
        _pendingRemote = null;
        if (!isClosed) {
          emit(state.copyWith(status: .readOnly, readOnly: true));
          addError(error, stackTrace);
        }
        return false;
      } on Object catch (error, stackTrace) {
        _documentSaving = false;
        _drainRemote();
        if (isClosed || _deleteRequested) return false;
        emit(
          state.copyWith(
            status: _looksOffline(error) ? .offline : .failure,
          ),
        );
        addError(error, stackTrace);
        return false;
      }
    }
    return false;
  }

  void _applySnapshot(List<Object?> document, int revision) {
    if (revision <= _baseRevision) return;
    final serverDoc = _documentDelta(document);
    final currentDoc = controller.document.toDelta();
    final patch = rebaseLocalDeltaPatch(
      synced: _syncedDelta,
      local: currentDoc,
      server: serverDoc,
    );
    if (patch.isNotEmpty) {
      controller.compose(patch, controller.selection, ChangeSource.remote);
    }
    _syncedDelta = serverDoc;
    _baseRevision = revision;
  }

  bool _looksOffline(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('connection failed') ||
        message.contains('clientexception');
  }

  Future<bool> delete() async {
    if (!state.canDelete || _deleteRequested) return false;
    _deleteRequested = true;
    _debounce?.cancel();
    _debounce = null;
    _titleDebounce?.cancel();
    _titleDebounce = null;
    final active = _saveTask;
    if (active != null) await active;
    final titleSave = _titleSaveTask;
    if (titleSave != null) await titleSave;
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
    _discardRequested = true;
    _debounce?.cancel();
    _debounce = null;
    _titleDebounce?.cancel();
    _titleDebounce = null;
    _pendingRemote = null;
    if (!isClosed) {
      emit(
        state.copyWith(
          title: _syncedTitle,
          persistedRevision: state.revision,
          status: .clean,
        ),
      );
    }
  }

  void insertImage(String url) {
    if (isClosed) return;
    final index = _insertionIndex();
    controller.replaceText(
      index,
      0,
      BlockEmbed.image(url),
      TextSelection.collapsed(offset: index + 1),
    );
  }

  void insertDrawing({required String url, required String strokesJson}) {
    if (isClosed) return;
    final index = _insertionIndex();
    controller.replaceText(
      index,
      0,
      Embeddable('note-drawing', {'url': url, 'strokes': strokesJson}),
      TextSelection.collapsed(offset: index + 1),
    );
  }

  int _insertionIndex() {
    final offset = controller.selection.baseOffset;
    return offset < 0 ? controller.document.length - 1 : offset;
  }

  Future<void> startVoiceInput({required String mutedColorHex}) async {
    if (state.voiceStatus == .listening || isClosed) return;
    _voiceMutedColorHex = mutedColorHex;
    final available = await _speech.initialize(
      onError: (error) {
        if (!isClosed) {
          emit(state.copyWith(voiceStatus: .error));
          addError(StateError(error.errorMsg));
        }
      },
    );
    if (!available) {
      if (!isClosed) emit(state.copyWith(voiceStatus: .unavailable));
      return;
    }
    _voiceAnchor = _insertionIndex();
    _voicePreviewLength = 0;
    if (!isClosed) emit(state.copyWith(voiceStatus: .listening));
    await _speech.listen(
      onResult: _onVoiceResult,
      listenOptions: SpeechListenOptions(
        localeId: 'ru_RU',
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stopVoiceInput() async {
    await _speech.stop();
    if (!isClosed && state.voiceStatus == .listening) {
      emit(state.copyWith(voiceStatus: .idle));
    }
  }

  void _onVoiceResult(SpeechRecognitionResult result) {
    final anchor = _voiceAnchor;
    if (isClosed || anchor == null) return;
    final words = result.recognizedWords;
    if (words.isEmpty && !result.finalResult) return;
    controller.replaceText(
      anchor,
      _voicePreviewLength,
      words,
      TextSelection.collapsed(offset: anchor + words.length),
    );
    if (!result.finalResult) {
      if (words.isNotEmpty) {
        controller.formatText(
          anchor,
          words.length,
          ColorAttribute(_voiceMutedColorHex),
        );
      }
      _voicePreviewLength = words.length;
      return;
    }
    if (words.isNotEmpty) {
      controller.formatText(anchor, words.length, const ColorAttribute(null));
    }
    _voiceAnchor = null;
    _voicePreviewLength = 0;
    if (!isClosed) emit(state.copyWith(voiceStatus: .idle));
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    _titleDebounce?.cancel();
    await _speech.cancel();
    if (!_deleteRequested && !_discardRequested) await flush();
    await _documentSubscription?.cancel();
    await _editorsSubscription?.cancel();
    await _changesSubscription?.cancel();
    await _connectionsSubscription?.cancel();
    await _realtime?.close();
    controller.dispose();
    return super.close();
  }
}
