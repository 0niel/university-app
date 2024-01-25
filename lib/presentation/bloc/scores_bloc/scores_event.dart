part of 'scores_bloc.dart';

abstract class ScoresEvent extends Equatable {
  const ScoresEvent();
}

class LoadScores extends ScoresEvent with AnalyticsEventMixin {
  const LoadScores({required this.studentCode});

  final String studentCode;

  @override
  List<Object> get props => [studentCode];

  @override
  AnalyticsEvent get event => const AnalyticsEvent('LoadScores');
}

class ChangeSelectedScoresSemester extends ScoresEvent {
  final String semester;

  const ChangeSelectedScoresSemester({
    required this.semester,
  });

  @override
  List<Object> get props => [semester];
}
