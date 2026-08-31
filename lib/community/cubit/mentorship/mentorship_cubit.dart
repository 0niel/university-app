import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship_status.dart';
import 'package:rtu_mirea_app/community/models/models.dart';

part 'mentorship_cubit.freezed.dart';
part 'mentorship_state.dart';

class MentorshipCubit extends Cubit<MentorshipState> {
  factory MentorshipCubit({required CampusRepository repository}) =>
      MentorshipCubit._(repository);

  MentorshipCubit._(this._repository) : super(const MentorshipState());

  final CampusRepository _repository;
  var _loadRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final mentors = await _repository.getMentors();
      if (!_isCurrent(revision)) return false;
      emit(
        state.copyWith(
          status: .ready,
          mentors: mentors,
          requestsStatus: .loading,
        ),
      );
      return await _loadRequests(revision);
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> _loadRequests(int revision) async {
    try {
      final requests = await _repository.getMyMentorRequests();
      if (!_isCurrent(revision)) return false;
      emit(
        state.copyWith(requests: requests, requestsStatus: .ready),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(requestsStatus: .failure));
      addError(error, stackTrace);
      return true;
    }
  }

  Future<bool> saveProfile(MentorProfileDraft draft) async {
    if (state.isSavingProfile || draft.topics.isEmpty) return false;
    emit(state.copyWith(isSavingProfile: true));
    try {
      await _repository.upsertMentorProfile(
        topics: _normalized(draft.topics),
        bio: draft.bio.trim(),
        level: draft.level.trim(),
        formats: _normalized(draft.formats),
        price: draft.price.clamp(0, 1000000),
      );
      if (isClosed) return false;
      emit(state.copyWith(isSavingProfile: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(isSavingProfile: false));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> deleteProfile() async {
    if (state.isSavingProfile || state.myProfile == null) return false;
    emit(state.copyWith(isSavingProfile: true));
    try {
      await _repository.deleteMentorProfile();
      if (isClosed) return false;
      emit(state.copyWith(isSavingProfile: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(isSavingProfile: false));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> sendRequest(MentorRequestDraft draft) async {
    final mentorId = draft.mentorUserId;
    if (mentorId.isEmpty || state.pendingMentorIds.contains(mentorId)) {
      return false;
    }
    _setPendingMentor(mentorId, pending: true);
    try {
      await _repository.createMentorRequest(
        mentorUserId: mentorId,
        topic: draft.topic.trim(),
        whenSlot: draft.whenSlot.wireValue,
        message: draft.message.trim(),
      );
      if (isClosed) return false;
      _setPendingMentor(mentorId, pending: false);
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        _setPendingMentor(mentorId, pending: false);
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> actOnRequest(
    String requestId,
    MentorRequestAction action,
  ) async {
    if (state.pendingRequestIds.contains(requestId)) return false;
    final request = state.requests.firstWhereOrNull(
      (candidate) => candidate.id == requestId,
    );
    if (request == null) return false;
    emit(
      state.copyWith(
        pendingRequestIds: {...state.pendingRequestIds, requestId},
      ),
    );
    try {
      await _repository.actOnMentorRequest(id: requestId, action: action);
      if (isClosed) return false;
      _clearPendingRequest(requestId);
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        _clearPendingRequest(requestId);
        addError(error, stackTrace);
      }
      return false;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;

  List<String> _normalized(List<String> values) => {
    for (final value in values)
      if (value.trim().isNotEmpty) value.trim(),
  }.toList(growable: false);

  void _setPendingMentor(String mentorId, {required bool pending}) {
    final ids = {...state.pendingMentorIds};
    if (pending) {
      ids.add(mentorId);
    } else {
      ids.remove(mentorId);
    }
    emit(state.copyWith(pendingMentorIds: ids));
  }

  void _clearPendingRequest(String requestId) {
    emit(
      state.copyWith(
        pendingRequestIds: {...state.pendingRequestIds}..remove(requestId),
      ),
    );
  }
}
