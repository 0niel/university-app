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
import 'package:rtu_mirea_app/community/data/note_draft_store.dart';
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
    String? currentUserId,
    NoteDraftStore? draftStore,
    SpeechToText? speech,
    Duration saveDebounce = const Duration(milliseconds: 1500),
    Duration closeTimeout = const Duration(seconds: 8),
  }) {
    final delta = _initialDelta(note);
    return NoteEditorCubit._(
      repository,
      note,
      editorName,
      saveDebounce,
      delta,
      currentUserId,
      draftStore,
      closeTimeout,
      speech ?? SpeechToText(),
    );
  }

  NoteEditorCubit._(
    this._repository,
    CollabNote note,
    String editorName,
    this._saveDebounce,
    Delta initialDelta,
    this._currentUserId,
    NoteDraftStore? draftStore,
    this._closeTimeout,
    this._speech,
  ) : _noteId = note.id,
      _draftStore = _currentUserId?.isNotEmpty == true ? draftStore : null,
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
    _restoreLocalDraft(note);
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
  final String? _currentUserId;
  final NoteDraftStore? _draftStore;
  final Duration _closeTimeout;
  final Duration _saveDebounce;
  final SpeechToText _speech;

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
  int _voiceGeneration = 0;
  String _voiceMutedColorHex = '';
  var _deleteRequested = false;
  var _discardRequested = false;
  var _documentSaving = false;
  CollabNoteChange? _pendingRemote;
  NoteEditorStatus? _titleFailure;
  var _titleGeneration = 0;
  var _resyncAgain = false;
  String? _draftToken;
  var _draftGeneration = 0;
  List<Object?>? _submittedDocument;
  String? _submittedTitle;
  Delta? _recoveryServerDocument;
  int? _recoveryServerRevision;
  String? _recoveryServerTitle;
  Future<void>? _localTask;
  Future<void>? _closeTask;
  var _localDraftSaveFailed = false;

  bool get localDraftSaveFailed => _localDraftSaveFailed;
  bool get canRecoverLocally => _draftStore != null;

  bool get hasRecoveryConflict =>
      _recoveryServerDocument != null || _recoveryServerTitle != null;
  String? get recoveryServerTitle => _recoveryServerTitle;

  bool get _hasLocalDraft =>
      _hasTitleDraft ||
      controller.document.toDelta() != _syncedDelta ||
      hasRecoveryConflict ||
      _submittedDocument != null ||
      _submittedTitle != null;

  void _restoreLocalDraft(CollabNote note) {
    final store = _draftStore;
    final userId = _currentUserId;
    if (store == null || userId == null) return;
    try {
      final draft = store.read(userId: userId, noteId: _noteId);
      if (draft == null) return;
      final base = _documentDelta(draft.baseDocument);
      final local = _documentDelta(draft.document);
      final submitted = draft.submittedDocument == null
          ? null
          : _documentDelta(draft.submittedDocument!);
      final server = _syncedDelta;
      final documentConflict =
          note.documentRevision < draft.baseRevision ||
          submitted != null &&
              note.documentRevision > draft.baseRevision &&
              server != submitted &&
              server != local &&
              server != base;
      final recovered = documentConflict || server == base
          ? local
          : server == local || server == submitted
          ? (server == local ? server : server.compose(submitted!.diff(local)))
          : local.compose(
              rebaseLocalDeltaPatch(synced: base, local: local, server: server),
            );
      if (documentConflict) {
        _recoveryServerDocument = server;
        _recoveryServerRevision = note.documentRevision;
        _syncedDelta = base;
        _baseRevision = draft.baseRevision;
        _submittedDocument = draft.submittedDocument;
      }
      final changedTitle = draft.title.trim() != draft.baseTitle.trim();
      if (changedTitle &&
          note.title != draft.title &&
          (draft.titleConflict ||
              note.title != draft.baseTitle &&
                  note.title != draft.submittedTitle)) {
        _recoveryServerTitle = note.title;
      }
      final title = changedTitle ? draft.title : note.title;
      controller.compose(
        server.diff(recovered),
        const TextSelection.collapsed(offset: 0),
        ChangeSource.remote,
      );
      _draftToken = draft.token;
      final dirty = recovered != _syncedDelta;
      emit(
        state.copyWith(
          title: title,
          revision: dirty ? 1 : 0,
          status: hasRecoveryConflict
              ? .conflict
              : (dirty || _hasTitleDraftFor(title) ? .dirty : .saved),
        ),
      );
      if (_hasLocalDraft) {
        unawaited(persistLocalDraft());
        if (!hasRecoveryConflict) {
          _debounce = Timer(_saveDebounce, () => unawaited(flush()));
        }
      } else {
        unawaited(_removeLocalDraft());
      }
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  bool _hasTitleDraftFor(String title) => title.trim() != _syncedTitle.trim();

  Future<bool> persistLocalDraft() async {
    final store = _draftStore;
    final userId = _currentUserId;
    if (store == null ||
        userId == null ||
        _discardRequested ||
        _deleteRequested ||
        isClosed ||
        !_hasLocalDraft) {
      return true;
    }
    final token = '$_clientId:${++_draftGeneration}';
    final previousToken = _draftToken;
    _draftToken = token;
    try {
      final task = store.writeIfCurrent(
        NoteDraft(
          noteId: _noteId,
          userId: userId,
          token: token,
          baseRevision: _baseRevision,
          baseDocument: _syncedDelta.toJson(),
          document: controller.document.toDelta().toJson(),
          baseTitle: _syncedTitle,
          title: state.title,
          submittedDocument: _submittedDocument,
          submittedTitle: _submittedTitle,
          titleConflict: _recoveryServerTitle != null,
        ),
        expectedToken: previousToken,
      );
      _localTask = task.then<void>((_) {}, onError: (Object _) {});
      if (!await task) {
        if (_draftToken == token) _draftToken = previousToken;
        throw StateError('A newer editor owns the local note draft');
      }
      _localDraftSaveFailed = false;
      return true;
    } on Object catch (error, stackTrace) {
      _localDraftSaveFailed = true;
      if (!isClosed && !_discardRequested && !_deleteRequested) {
        emit(state.copyWith(status: .failure));
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<void> _removeLocalDraft() async {
    final token = _draftToken;
    final store = _draftStore;
    final userId = _currentUserId;
    if (token == null || store == null || userId == null) return;
    try {
      final task = store.remove(userId: userId, noteId: _noteId, token: token);
      _localTask = task.then<void>((_) {}, onError: (Object _) {});
      await task;
      if (_draftToken == token) _draftToken = null;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _checkpointAfterSave() async {
    if (_hasLocalDraft) {
      await persistLocalDraft();
    } else {
      await _removeLocalDraft();
    }
  }

  void resolveRecoveryConflict({required bool keepLocal}) {
    if (!hasRecoveryConflict ||
        isClosed ||
        _deleteRequested ||
        _discardRequested) {
      return;
    }
    final server = _recoveryServerDocument;
    if (server != null) {
      if (!keepLocal) {
        controller.compose(
          controller.document.toDelta().diff(server),
          controller.selection,
          ChangeSource.remote,
        );
      }
      _syncedDelta = server;
      _baseRevision = _recoveryServerRevision!;
    }
    final serverTitle = _recoveryServerTitle;
    if (serverTitle != null) _syncedTitle = serverTitle;
    _recoveryServerDocument = null;
    _recoveryServerRevision = null;
    _recoveryServerTitle = null;
    _submittedDocument = null;
    _submittedTitle = null;
    final dirty = controller.document.toDelta() != _syncedDelta;
    final title = !keepLocal && serverTitle != null ? serverTitle : state.title;
    emit(
      state.copyWith(
        title: title,
        revision: state.revision + 1,
        persistedRevision: dirty ? state.persistedRevision : state.revision + 1,
        status: dirty || _hasTitleDraftFor(title) ? .dirty : .saved,
      ),
    );
    unawaited(_checkpointAfterSave());
    _debounce?.cancel();
    if (state.hasUnsavedChanges) {
      _debounce = Timer(_saveDebounce, () => unawaited(flush()));
    }
  }

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
    unawaited(persistLocalDraft());
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
    if (hasRecoveryConflict) return false;
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
        _submittedTitle = title;
        await persistLocalDraft();
        if (isClosed || _discardRequested || _deleteRequested) return false;
        await _repository.renameGroupNote(_noteId, title);
        _syncedTitle = title;
        _submittedTitle = null;
        _titleFailure = null;
        if (isClosed || _deleteRequested || _discardRequested) return false;
        emit(state.copyWith(status: _settledStatus));
        await _checkpointAfterSave();
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
    unawaited(persistLocalDraft());
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
      if (_recoveryServerDocument != null) {
        if (change.revision > (_recoveryServerRevision ?? 0)) {
          _recoveryServerDocument = _documentDelta(change.document);
          _recoveryServerRevision = change.revision;
        }
        return;
      }
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
      if (_recoveryServerTitle != null) _recoveryServerTitle = note.title;
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
        state.status == .deleted ||
        hasRecoveryConflict) {
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
        await _checkpointAfterSave();
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
        _submittedDocument = localDoc.toJson();
        await persistLocalDraft();
        if (isClosed || _discardRequested || _deleteRequested) {
          _documentSaving = false;
          return false;
        }
        final result = await _repository.saveGroupNoteDocument(
          id: _noteId,
          document: localDoc.toJson(),
          expectedRevision: _baseRevision,
        );
        _documentSaving = false;
        _submittedDocument = null;
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
        await _checkpointAfterSave();
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
    final patch = currentDoc == serverDoc
        ? Delta()
        : rebaseLocalDeltaPatch(
            synced: _syncedDelta,
            local: currentDoc,
            server: serverDoc,
          );
    if (patch.isNotEmpty) {
      controller.compose(patch, controller.selection, ChangeSource.remote);
    }
    _syncedDelta = serverDoc;
    _baseRevision = revision;
    unawaited(persistLocalDraft());
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
      await _removeLocalDraft();
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
    unawaited(_removeLocalDraft());
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
    if (state.voiceStatus == .listening || !_canAcceptVoice) return;
    final generation = ++_voiceGeneration;
    _voiceMutedColorHex = mutedColorHex;
    final available = await _speech.initialize(
      onError: (error) {
        if (!isClosed && generation == _voiceGeneration) {
          _voiceGeneration++;
          _voiceAnchor = null;
          _voicePreviewLength = 0;
          emit(state.copyWith(voiceStatus: .error));
          addError(StateError(error.errorMsg));
        }
      },
    );
    if (!_canAcceptVoice || generation != _voiceGeneration) return;
    if (!available) {
      if (!isClosed) emit(state.copyWith(voiceStatus: .unavailable));
      return;
    }
    _voiceAnchor = _insertionIndex();
    _voicePreviewLength = 0;
    if (!isClosed) emit(state.copyWith(voiceStatus: .listening));
    await _speech.listen(
      onResult: (result) {
        if (generation == _voiceGeneration) _onVoiceResult(result);
      },
      listenOptions: SpeechListenOptions(
        localeId: 'ru_RU',
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stopVoiceInput() async {
    _voiceGeneration++;
    final anchor = _voiceAnchor;
    if (_canAcceptVoice &&
        anchor != null &&
        _voicePreviewLength > 0 &&
        anchor + _voicePreviewLength < controller.document.length) {
      controller.formatText(
        anchor,
        _voicePreviewLength,
        const ColorAttribute(null),
      );
    }
    _voiceAnchor = null;
    _voicePreviewLength = 0;
    if (!isClosed && state.voiceStatus == .listening) {
      emit(state.copyWith(voiceStatus: .idle));
    }
    await _speech.stop();
  }

  bool get _canAcceptVoice =>
      !isClosed &&
      !_deleteRequested &&
      !_discardRequested &&
      !controller.readOnly &&
      !state.readOnly;

  void _onVoiceResult(SpeechRecognitionResult result) {
    final anchor = _voiceAnchor;
    if (!_canAcceptVoice || anchor == null || state.voiceStatus != .listening) {
      return;
    }
    if (anchor < 0 ||
        anchor + _voicePreviewLength >= controller.document.length) {
      unawaited(stopVoiceInput());
      return;
    }
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
    _voiceGeneration++;
    if (!isClosed) emit(state.copyWith(voiceStatus: .idle));
  }

  @override
  Future<void> close() =>
      _closeTask ??= _closeEditor().then((_) => super.close());

  Future<void> _closeEditor() async {
    _voiceGeneration++;
    _voiceAnchor = null;
    _debounce?.cancel();
    _titleDebounce?.cancel();
    await persistLocalDraft();
    if (_localTask case final task?) await task;
    await _speech.cancel();
    if (!_deleteRequested && !_discardRequested) {
      await flush().timeout(_closeTimeout, onTimeout: () => false);
    }
    await _documentSubscription?.cancel();
    await _editorsSubscription?.cancel();
    await _changesSubscription?.cancel();
    await _connectionsSubscription?.cancel();
    await _realtime?.close();
    controller.dispose();
  }
}
