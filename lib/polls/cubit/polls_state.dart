part of 'polls_cubit.dart';

@freezed
abstract class PollsState with _$PollsState {
  const factory PollsState({
    @Default(PollsStatus.initial) PollsStatus status,
    @Default(<Poll>[]) List<Poll> polls,
    @Default(<String>{}) Set<String> pendingPollIds,
    @Default(<String>{}) Set<String> deletingPollIds,
  }) = _PollsState;

  const PollsState._();
}
