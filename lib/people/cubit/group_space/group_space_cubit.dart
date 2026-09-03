import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_mutation_failure.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_status.dart';

part 'group_space_cubit.freezed.dart';
part 'group_space_state.dart';

class GroupSpaceCubit extends Cubit<GroupSpaceState> {
  factory GroupSpaceCubit({required CampusRepository repository}) =>
      GroupSpaceCubit._(repository);

  GroupSpaceCubit._(this._repository) : super(const GroupSpaceState());

  final CampusRepository _repository;
  var _loadRevision = 0;
  String? _realtimeGroupId;
  GroupSpaceRealtimeSession? _realtimeSession;
  GroupSpacePresenceSession? _presenceSession;
  StreamSubscription<void>? _realtimeSub;
  StreamSubscription<int>? _presenceSub;

  Future<void> load() async {
    final revision = ++_loadRevision;
    final coldLoad = state.status != .success;
    emit(
      state.copyWith(
        status: coldLoad ? .loading : state.status,
        isRefreshing: !coldLoad,
        mutationFailure: null,
      ),
    );
    try {
      final space = await _repository.getGroupSpace();
      if (revision != _loadRevision) return;
      final notesPreview = space.hasGroup
          ? await _fetchNotesPreview()
          : const <CollabNote>[];
      if (revision != _loadRevision) return;
      emit(
        state.copyWith(
          status: .success,
          space: _preservePendingLikes(space),
          notesPreview: notesPreview,
          isRefreshing: false,
        ),
      );
      _syncRealtime(space);
    } on Object catch (error, stackTrace) {
      if (revision != _loadRevision) return;
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: coldLoad ? .failure : state.status,
          isRefreshing: false,
          mutationFailure: coldLoad ? null : .refresh,
        ),
      );
    }
  }

  Future<List<CollabNote>> _fetchNotesPreview() async {
    try {
      return await _repository.getGroupNotes();
    } on Object {
      return state.notesPreview;
    }
  }

  Future<bool> addLink({
    required String title,
    required String url,
    required String emoji,
    required String kind,
  }) => _mutate(
    failure: .link,
    operation: () => _repository.addGroupLink(
      title: title,
      url: url,
      emoji: emoji,
      kind: kind,
    ),
  );

  Future<bool> createPost({
    required String title,
    required String body,
    required bool announcement,
    bool pinned = false,
  }) => _mutate(
    failure: .post,
    operation: () => _repository.createGroupPost(
      title: title,
      body: body,
      kind: announcement ? 'announcement' : 'note',
      pinned: announcement || pinned,
    ),
  );

  Future<bool> setMyBirthDate(DateTime date) => _mutate(
    failure: .birthday,
    operation: () => _repository.setMyBirthDate(date),
  );

  Future<bool> deleteLink(String id) async {
    if (state.pendingLinkDeleteIds.contains(id)) return false;
    emit(
      state.copyWith(
        pendingLinkDeleteIds: {...state.pendingLinkDeleteIds, id},
      ),
    );
    final ok = await _mutate(
      failure: .deleteLink,
      operation: () => _repository.deleteGroupLink(id),
    );
    emit(
      state.copyWith(
        pendingLinkDeleteIds: {...state.pendingLinkDeleteIds}..remove(id),
      ),
    );
    return ok;
  }

  Future<void> toggleLike(String noteId) async {
    if (state.pendingLikeIds.contains(noteId)) return;
    final original = state.space.notes.firstWhereOrNull(
      (note) => note.id == noteId,
    );
    if (original == null) return;
    _invalidateLoads();
    final optimisticLiked = !original.likedByMe;
    _setLike(noteId, optimisticLiked, pending: true);
    try {
      final liked = await _repository.toggleGroupPostLike(noteId);
      _invalidateLoads();
      _setLike(noteId, liked, pending: false);
    } on Object catch (error, stackTrace) {
      _invalidateLoads();
      addError(error, stackTrace);
      _setLike(noteId, original.likedByMe, pending: false, failed: true);
    }
  }

  Future<void> loadComments(String postId) async {
    if (state.loadingCommentPostIds.contains(postId)) return;
    emit(
      state.copyWith(
        loadingCommentPostIds: {...state.loadingCommentPostIds, postId},
      ),
    );
    try {
      final comments = await _repository.getGroupPostComments(postId);
      if (isClosed) return;
      emit(
        state.copyWith(
          comments: {...state.comments, postId: comments},
          loadingCommentPostIds: {...state.loadingCommentPostIds}
            ..remove(postId),
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed) return;
      addError(error, stackTrace);
      emit(
        state.copyWith(
          loadingCommentPostIds: {...state.loadingCommentPostIds}
            ..remove(postId),
          mutationFailure: .comment,
        ),
      );
    }
  }

  Future<bool> addComment({
    required String postId,
    required String body,
  }) async {
    if (state.isSubmittingComment) return false;
    emit(state.copyWith(isSubmittingComment: true, mutationFailure: null));
    try {
      final comment = await _repository.addGroupPostComment(
        postId: postId,
        body: body,
      );
      if (isClosed) return false;
      final existing = state.comments[postId] ?? const <GroupPostComment>[];
      emit(
        state.copyWith(
          isSubmittingComment: false,
          comments: {
            ...state.comments,
            postId: [...existing, comment],
          },
          space: _bumpCommentsCount(postId, delta: 1),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (isClosed) return false;
      addError(error, stackTrace);
      emit(
        state.copyWith(isSubmittingComment: false, mutationFailure: .comment),
      );
      return false;
    }
  }

  Future<bool> deleteComment({
    required String id,
    required String postId,
  }) async {
    if (state.pendingCommentDeleteIds.contains(id)) return false;
    emit(
      state.copyWith(
        pendingCommentDeleteIds: {...state.pendingCommentDeleteIds, id},
      ),
    );
    try {
      await _repository.deleteGroupPostComment(id);
      if (isClosed) return false;
      final existing = state.comments[postId] ?? const <GroupPostComment>[];
      emit(
        state.copyWith(
          pendingCommentDeleteIds: {...state.pendingCommentDeleteIds}
            ..remove(id),
          comments: {
            ...state.comments,
            postId: existing.where((comment) => comment.id != id).toList(),
          },
          space: _bumpCommentsCount(postId, delta: -1),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (isClosed) return false;
      addError(error, stackTrace);
      emit(
        state.copyWith(
          pendingCommentDeleteIds: {...state.pendingCommentDeleteIds}
            ..remove(id),
          mutationFailure: .deleteComment,
        ),
      );
      return false;
    }
  }

  void clearMutationFailure() => emit(state.copyWith(mutationFailure: null));

  Future<bool> _mutate({
    required GroupSpaceMutationFailure failure,
    required Future<Object?> Function() operation,
  }) async {
    _invalidateLoads();
    try {
      await operation();
      await load();
      return true;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(mutationFailure: failure));
      return false;
    }
  }

  GroupSpace _preservePendingLikes(GroupSpace incoming) {
    if (state.pendingLikeIds.isEmpty) return incoming;
    final pending = {
      for (final note in state.space.notes)
        if (state.pendingLikeIds.contains(note.id)) note.id: note,
    };
    return incoming.copyWith(
      notes: [
        for (final note in incoming.notes) pending[note.id] ?? note,
      ],
    );
  }

  GroupSpace _bumpCommentsCount(String postId, {required int delta}) {
    final space = state.space;
    final announcement = space.announcement;
    if (announcement != null && announcement.id == postId) {
      return space.copyWith(
        announcement: announcement.copyWith(
          commentsCount: (announcement.commentsCount + delta).clamp(
            0,
            1 << 31,
          ),
        ),
      );
    }
    return space.copyWith(
      notes: [
        for (final note in space.notes)
          if (note.id == postId)
            note.copyWith(
              commentsCount: (note.commentsCount + delta).clamp(0, 1 << 31),
            )
          else
            note,
      ],
    );
  }

  void _invalidateLoads() {
    _loadRevision++;
    if (state.isRefreshing) {
      emit(state.copyWith(isRefreshing: false));
    }
  }

  void _setLike(
    String noteId,
    bool liked, {
    required bool pending,
    bool failed = false,
  }) {
    final notes = state.space.notes
        .map(
          (note) => note.id == noteId
              ? note.copyWith(
                  likedByMe: liked,
                  likes:
                      (note.likes +
                              (liked == note.likedByMe ? 0 : (liked ? 1 : -1)))
                          .clamp(0, 1 << 31),
                )
              : note,
        )
        .toList();
    final pendingIds = {...state.pendingLikeIds};
    pending ? pendingIds.add(noteId) : pendingIds.remove(noteId);
    emit(
      state.copyWith(
        space: state.space.copyWith(notes: notes),
        pendingLikeIds: pendingIds,
        mutationFailure: failed ? .like : null,
      ),
    );
  }

  void _syncRealtime(GroupSpace space) {
    final groupId = space.hasGroup ? space.groupId : null;
    if (groupId == _realtimeGroupId) return;
    _realtimeGroupId = groupId;

    final previousSub = _realtimeSub;
    final previousPresenceSub = _presenceSub;
    final previousSession = _realtimeSession;
    final previousPresenceSession = _presenceSession;
    _realtimeSub = null;
    _presenceSub = null;
    _realtimeSession = null;
    _presenceSession = null;
    unawaited(previousSub?.cancel());
    unawaited(previousPresenceSub?.cancel());
    unawaited(previousSession?.close());
    unawaited(previousPresenceSession?.close());

    if (groupId == null || groupId.isEmpty) return;

    final realtime = _repository.openGroupSpaceRealtime(groupId);
    final presence = _repository.openGroupSpacePresence(groupId);
    _realtimeSession = realtime;
    _presenceSession = presence;
    _realtimeSub = realtime.changes.listen(
      (_) => unawaited(load()),
      onError: (Object _, StackTrace _) {},
    );
    _presenceSub = presence.onlineCount.listen(
      (count) {
        if (isClosed) return;
        emit(state.copyWith(onlineCount: count < 1 ? 1 : count));
      },
      onError: (Object _, StackTrace _) {},
    );
  }

  @override
  Future<void> close() async {
    await _realtimeSub?.cancel();
    await _presenceSub?.cancel();
    await _realtimeSession?.close();
    await _presenceSession?.close();
    _realtimeSub = null;
    _presenceSub = null;
    _realtimeSession = null;
    _presenceSession = null;
    return super.close();
  }
}
