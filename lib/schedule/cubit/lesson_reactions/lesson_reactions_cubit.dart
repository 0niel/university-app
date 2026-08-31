import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'lesson_reactions_cubit.freezed.dart';
part 'lesson_reactions_cubit.g.dart';
part 'lesson_reactions_state.dart';

class LessonReactionsCubit extends HydratedCubit<LessonReactionsState> {
  factory LessonReactionsCubit({
    required ScheduleRepository scheduleRepository,
  }) => LessonReactionsCubit._(scheduleRepository);

  LessonReactionsCubit._(this._scheduleRepository)
    : super(const LessonReactionsState());

  final ScheduleRepository _scheduleRepository;
  final Map<String, int> _slotVersions = {};
  final Map<String, Future<void>> _mutationQueues = {};

  Future<void> loadSummary({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
  }) async {
    final operation = _beginOperation(subjectName, lessonDate, lessonBells);
    try {
      final response = await _scheduleRepository.getLessonReactionSummary(
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBellsNumber: lessonBells.number ?? 0,
      );
      if (isClosed || !_isLatestOperation(operation)) return;
      _applyLoadedSummary(
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBells: lessonBells,
        counts: ReactionCounts.fromJson(response.counts),
        userReaction: _reactionTypeFromWire(response.userReaction),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _applyLoadedSummary({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    required ReactionCounts counts,
    required ReactionType? userReaction,
  }) {
    final index = _indexOf(subjectName, lessonDate, lessonBells);
    if (counts.isEmpty && userReaction == null) {
      if (index >= 0) {
        final summaries = [...state.summaries]..removeAt(index);
        emit(state.copyWith(summaries: summaries));
      }
      return;
    }

    final summary = LessonReactionSummary(
      subjectName: subjectName,
      lessonDate: lessonDate,
      lessonBells: lessonBells,
      reactionCounts: counts,
      userReaction: userReaction,
    );
    if (index < 0) {
      emit(state.copyWith(summaries: [...state.summaries, summary]));
      return;
    }
    _replaceAt(index, summary);
  }

  Future<void> addReaction({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    required ReactionType reactionType,
  }) async {
    final operation = _beginOperation(subjectName, lessonDate, lessonBells);
    await _enqueueMutation(
      operation.key,
      () => _addReaction(
        operation: operation,
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBells: lessonBells,
        reactionType: reactionType,
      ),
    );
  }

  Future<void> _addReaction({
    required ({String key, int version}) operation,
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    required ReactionType reactionType,
  }) async {
    if (isClosed) return;
    try {
      await _scheduleRepository.postLessonReaction(
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBellsNumber: lessonBells.number ?? 0,
        reactionType: reactionType.name,
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return;
    }
    if (isClosed || !_isLatestOperation(operation)) return;

    final index = _indexOf(subjectName, lessonDate, lessonBells);
    if (index < 0) {
      emit(
        state.copyWith(
          summaries: [
            ...state.summaries,
            LessonReactionSummary(
              subjectName: subjectName,
              lessonDate: lessonDate,
              lessonBells: lessonBells,
              reactionCounts: ReactionCounts.single(reactionType, 1),
              userReaction: reactionType,
            ),
          ],
        ),
      );
      return;
    }

    final summary = state.summaries.elementAtOrNull(index);
    if (summary == null) return;
    final counts = summary.reactionCounts
        .decremented(summary.userReaction)
        .incremented(reactionType);

    _replaceAt(
      index,
      summary.copyWith(
        reactionCounts: counts,
        userReaction: reactionType,
      ),
    );
  }

  Future<void> removeReaction({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
  }) async {
    final operation = _beginOperation(subjectName, lessonDate, lessonBells);
    await _enqueueMutation(
      operation.key,
      () => _removeReaction(
        operation: operation,
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBells: lessonBells,
      ),
    );
  }

  Future<void> _removeReaction({
    required ({String key, int version}) operation,
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
  }) async {
    if (isClosed) return;
    try {
      await _scheduleRepository.deleteLessonReaction(
        subjectName: subjectName,
        lessonDate: lessonDate,
        lessonBellsNumber: lessonBells.number ?? 0,
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return;
    }
    if (isClosed || !_isLatestOperation(operation)) return;

    final index = _indexOf(subjectName, lessonDate, lessonBells);
    if (index < 0) return;

    final summary = state.summaries.elementAtOrNull(index);
    if (summary == null) return;
    if (summary.userReaction == null) return;

    final counts = summary.reactionCounts.decremented(summary.userReaction);

    if (counts.isEmpty) {
      final summaries = [...state.summaries]..removeAt(index);
      emit(state.copyWith(summaries: summaries));
      return;
    }

    _replaceAt(
      index,
      summary.copyWith(
        reactionCounts: counts,
        userReaction: null,
      ),
    );
  }

  int _indexOf(String subjectName, DateTime lessonDate, LessonBells bells) {
    return state.summaries.indexWhere(
      (summary) =>
          summary.subjectName == subjectName &&
          summary.lessonDate.isAtSameMomentAs(lessonDate) &&
          summary.lessonBells == bells,
    );
  }

  LessonReactionSummary? summaryFor({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
  }) {
    final index = _indexOf(subjectName, lessonDate, lessonBells);
    return state.summaries.elementAtOrNull(index);
  }

  void _replaceAt(int index, LessonReactionSummary summary) {
    final summaries = [...state.summaries];
    summaries[index] = summary;
    emit(state.copyWith(summaries: summaries));
  }

  ReactionType? _reactionTypeFromWire(String? value) {
    if (value == null) return null;
    for (final type in ReactionType.values) {
      if (type.name == value) return type;
    }
    return null;
  }

  ({String key, int version}) _beginOperation(
    String subjectName,
    DateTime lessonDate,
    LessonBells lessonBells,
  ) {
    final key = _slotKey(subjectName, lessonDate, lessonBells);
    final version = (_slotVersions[key] ?? 0) + 1;
    _slotVersions[key] = version;
    return (key: key, version: version);
  }

  bool _isLatestOperation(({String key, int version}) operation) =>
      _slotVersions[operation.key] == operation.version;

  String _slotKey(
    String subjectName,
    DateTime lessonDate,
    LessonBells lessonBells,
  ) =>
      '$subjectName|${lessonDate.toUtc().toIso8601String()}|'
      '${lessonBells.number ?? 'none'}|${lessonBells.startTime}|'
      '${lessonBells.endTime}';

  Future<void> _enqueueMutation(
    String key,
    Future<void> Function() mutation,
  ) async {
    final previous = _mutationQueues[key] ?? Future<void>.value();
    final recovered = previous.then<void>(
      (_) => null,
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed) addError(error, stackTrace);
      },
    );
    final next = recovered.then((_) => mutation());
    _mutationQueues[key] = next;
    try {
      await next;
    } finally {
      if (identical(_mutationQueues[key], next)) {
        final _ = _mutationQueues.remove(key);
      }
    }
  }

  @override
  LessonReactionsState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(LessonReactionsState state) => state.toJson();
}
