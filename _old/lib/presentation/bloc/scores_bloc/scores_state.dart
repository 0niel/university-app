part of 'scores_bloc.dart';

abstract class ScoresState extends Equatable {
  const ScoresState();

  @override
  List<Object> get props => [];
}

class ScoresInitial extends ScoresState {}

class EmployeeInitial extends ScoresState {}

class ScoresLoading extends ScoresState {}

class ScoresLoaded extends ScoresState {
  final Map<String, List<Score>> scores;
  final String selectedSemester;

  const ScoresLoaded({required this.scores, required this.selectedSemester});

  @override
  List<Object> get props => [scores, selectedSemester];
}

class ScoresLoadError extends ScoresState {}
