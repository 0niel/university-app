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
      emit(
        state.copyWith(
          status: .success,
          space: _preservePendingLikes(space),
          isRefreshing: false,
        ),
      );
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
  }) => _mutate(
    failure: .post,
    operation: () => _repository.createGroupPost(
      title: title,
      body: body,
      kind: announcement ? 'announcement' : 'note',
      pinned: announcement,
    ),
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
}
