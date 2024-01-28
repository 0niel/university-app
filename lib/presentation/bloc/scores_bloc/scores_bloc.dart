import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/usecases/get_scores.dart';

part 'scores_event.dart';
part 'scores_state.dart';
part 'scores_bloc.g.dart';

class ScoresBloc extends HydratedBloc<ScoresEvent, ScoresState> {
  final GetScores getScores;

  static int getScoreByName(String name) {
    switch (name.toLowerCase()) {
      case "отлично":
        return 5;
      case "хорошо":
        return 4;
      case "удовлетворительно":
        return 3;
      case "зачтено":
        return -1;
      default:
        return 0;
    }
  }

  ScoresBloc({required this.getScores}) : super(const ScoresState()) {
    on<LoadScores>(_onLoadScores);
    on<ChangeSelectedScoresSemester>(_onChangeSelectedScoresSemester);
  }

  void _onChangeSelectedScoresSemester(
    ChangeSelectedScoresSemester event,
    Emitter<ScoresState> emit,
  ) async {
    if (state.status == ScoresStatus.loaded) {
      emit(state.copyWith(selectedSemester: event.semester));
    }
  }

  Map<String, List<Score>> _sortScores(Map<String, List<Score>> scores) {
    Map<String, List<Score>> newMap = {};

    final sortedKeys = scores.keys.toList()
      ..sort((a, b) => int.parse(a.split(' ')[0]).compareTo(int.parse(b.split(' ')[0])));

    for (final key in sortedKeys) {
      newMap[key] = scores[key]!;
    }

    return newMap;
  }

  void _onLoadScores(
    LoadScores event,
    Emitter<ScoresState> emit,
  ) async {
    if (state.status != ScoresStatus.loaded) {
      emit(state.copyWith(status: ScoresStatus.loading));

      final scores = await getScores();
      final studentCode = event.studentCode;

      scores.fold((failure) => emit(state.copyWith(status: ScoresStatus.error)), (result) {
        final scores = result[studentCode];

        if (scores == null) {
          emit(state.copyWith(status: ScoresStatus.error));
          return;
        }

        emit(
          state.copyWith(
            scores: _sortScores(scores),
            selectedSemester: scores.keys.last,
            status: ScoresStatus.loaded,
          ),
        );
      });
    }
  }

  @override
  ScoresState? fromJson(Map<String, dynamic> json) => ScoresState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScoresState state) => state.toJson();
}
