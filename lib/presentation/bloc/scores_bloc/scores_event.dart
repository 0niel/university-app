part of 'scores_bloc.dart';

abstract class ScoresEvent extends Equatable {
  const ScoresEvent();

  @override
  List<Object> get props => [];
}

class LoadScores extends ScoresEvent {
  const LoadScores({required this.studentCode});

  final String studentCode;

  @override
  List<Object> get props => [];
}

class ChangeSelectedScoresSemester extends ScoresEvent {
  final String semester;

  const ChangeSelectedScoresSemester({
    required this.semester,
  });

  @override
  List<Object> get props => [semester];
}
