part of 'scores_bloc.dart';

abstract class ScoresEvent extends Equatable {
  const ScoresEvent();

  @override
  List<Object> get props => [];
}

class LoadScores extends ScoresEvent {
  final String token;

  const LoadScores({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class ChangeSelectedScoresSemester extends ScoresEvent {
  final String semester;

  const ChangeSelectedScoresSemester({
    required this.semester,
  });

  @override
  List<Object> get props => [semester];
}
