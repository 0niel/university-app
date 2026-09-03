part of 'polls_cubit.dart';

@freezed
abstract class PollsState with _$PollsState {
  const factory PollsState({
    @Default(PollsStatus.initial) PollsStatus status,
    @Default(<Poll>[]) List<Poll> polls,
    @Default(PollFilter.all) PollFilter filter,
    PollCategory? category,
    @Default('') String query,
  }) = _PollsState;

  const PollsState._();

  int get openCount =>
      polls.where((poll) => !poll.isEnded && !poll.iParticipated).length;
}
