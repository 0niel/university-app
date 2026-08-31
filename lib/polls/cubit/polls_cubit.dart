import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'polls_state.dart';
part 'polls_cubit.freezed.dart';
part 'polls_status.dart';

class PollsCubit extends Cubit<PollsState> {
  PollsCubit({required this._campusRepository}) : super(const PollsState());

  final CampusRepository _campusRepository;

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final polls = await _campusRepository.getPolls();
      emit(state.copyWith(status: .populated, polls: polls));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<bool> submitVote(Poll poll, List<String> optionIds) async {
    if (optionIds.isEmpty) return false;
    if (state.pendingPollIds.contains(poll.id)) return false;
    emit(
      state.copyWith(pendingPollIds: {...state.pendingPollIds, poll.id}),
    );
    try {
      await _campusRepository.votePoll(pollId: poll.id, optionIds: optionIds);
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    } finally {
      emit(
        state.copyWith(
          pendingPollIds: {...state.pendingPollIds}..remove(poll.id),
        ),
      );
    }
  }

  Future<bool> createPoll({
    required String question,
    required List<String> options,
    PollType type = .single,
    bool isAnonymous = false,
    bool showResults = true,
    DateTime? expiresAt,
    int? correctIndex,
  }) async {
    try {
      await _campusRepository.createPoll(
        question: question,
        options: options,
        type: type,
        isAnonymous: isAnonymous,
        showResults: showResults,
        expiresAt: expiresAt,
        correctIndex: correctIndex,
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> deletePoll(Poll poll) async {
    if (state.deletingPollIds.contains(poll.id)) return false;
    emit(
      state.copyWith(deletingPollIds: {...state.deletingPollIds, poll.id}),
    );
    try {
      await _campusRepository.deletePoll(poll.id);
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    } finally {
      emit(
        state.copyWith(
          deletingPollIds: {...state.deletingPollIds}..remove(poll.id),
        ),
      );
    }
  }
}
