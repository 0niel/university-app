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

  void _onLoadScores(
    LoadScores event,
    Emitter<ScoresState> emit,
  ) async {
    if (state.runtimeType != ScoresLoaded) {
      emit(ScoresLoading());

      final scores = await getScores(GetScoresParams(event.token));

      scores.fold((failure) => emit(ScoresLoadError()), (result) {
        emit(ScoresLoaded(scores: result, selectedSemester: result.keys.last));
      });
    }
  }
}
