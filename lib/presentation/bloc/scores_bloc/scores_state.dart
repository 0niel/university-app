part of 'scores_bloc.dart';

enum ScoresStatus { initial, loading, loaded, error }

@JsonSerializable()
class ScoresState extends Equatable {
  const ScoresState({
    this.scores,
    this.selectedSemester,
    this.status = ScoresStatus.initial,
  });
  final Map<String, List<Score>>? scores;
  final String? selectedSemester;
  final ScoresStatus status;

  Map<int, double>? get averageRating {
    if (scores == null) return null;

    Map<int, double> rating = {};

    for (final scoresKey in scores!.keys.toList()) {
      final semesterScores = scores![scoresKey]!;
      final semester = int.parse(scoresKey.split(' ')[0]);

      int count = 0;
      double average = 0;
      for (final score in semesterScores) {
        final scoreValue = ScoresBloc.getScoreByName(score.result);

        if (scoreValue != -1) {
          count++;
          average += scoreValue;
        }
      }

      average = average / count;
      rating[semester] = double.parse(average.toStringAsFixed(2));
    }

    return rating;
  }

  ScoresState copyWith({
    Map<String, List<Score>>? scores,
    String? selectedSemester,
    ScoresStatus? status,
  }) {
    return ScoresState(
      scores: scores ?? this.scores,
      selectedSemester: selectedSemester ?? this.selectedSemester,
      status: status ?? this.status,
    );
  }

  factory ScoresState.fromJson(Map<String, dynamic> json) => _$ScoresStateFromJson(json);

  Map<String, dynamic> toJson() => _$ScoresStateToJson(this);

  @override
  List<Object?> get props => [scores, selectedSemester, status];
}
