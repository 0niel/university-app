import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/usecases/get_scores.dart';

part 'scores_event.dart';
part 'scores_state.dart';

class ScoresBloc extends Bloc<ScoresEvent, ScoresState> {
  final GetScores getScores;

  ScoresBloc({required this.getScores}) : super(ScoresInitial()) {
    on<LoadScores>(_onLoadScores);
    on<ChangeSelectedScoresSemester>(_onChangeSelectedScoresSemester);
  }

  void _onChangeSelectedScoresSemester(
    ChangeSelectedScoresSemester event,
    Emitter<ScoresState> emit,
  ) async {
    if (state is ScoresLoaded) {
      final scores = (state as ScoresLoaded).scores;
      emit(ScoresLoaded(scores: scores, selectedSemester: event.semester));
    }
  }

  Map<String, List<Score>> _sortScores(Map<String, List<Score>> scores) {
    Map<String, List<Score>> newMap = {};

    final sortedKeys = scores.keys.toList()
      ..sort((a, b) =>
          int.parse(a.split(' ')[0]).compareTo(int.parse(b.split(' ')[0])));

    for (final key in sortedKeys) {
      newMap[key] = scores[key]!;
    }

    return newMap;
  }

  void _onLoadScores(
    LoadScores event,
    Emitter<ScoresState> emit,
  ) async {
    if (state.runtimeType != ScoresLoaded) {
      emit(ScoresLoading());

      final scores = await getScores();
      final studentCode = event.studentCode;

      scores.fold((failure) => emit(ScoresLoadError()), (result) {
        final scores = result[studentCode];

        if (scores == null) {
          emit(ScoresLoadError());
          return;
        }

        emit(ScoresLoaded(
            scores: _sortScores(scores), selectedSemester: scores.keys.last));
      });
    }
  }
}
