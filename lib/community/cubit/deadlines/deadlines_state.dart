part of 'deadlines_cubit.dart';

@freezed
abstract class DeadlinesState with _$DeadlinesState {
  const factory DeadlinesState({
    @Default(DeadlinesStatus.initial) DeadlinesStatus status,
    @Default(<Deadline>[]) List<Deadline> deadlines,
    @Default(DeadlineFilter.all) DeadlineFilter filter,
    @Default(<String>{}) Set<String> pendingDeadlineIds,
    @Default(<String>{}) Set<String> pendingDeleteIds,
    @Default(false) bool isCreating,
    @Default(false) bool doneGroupExpanded,
  }) = _DeadlinesState;

  const DeadlinesState._();

  List<Deadline> get displayDeadlines => deadlines
      .where((deadline) => !pendingDeleteIds.contains(deadline.id))
      .toList(growable: false);

  List<Deadline> get activeDeadlines =>
      deadlines.where((deadline) => !deadline.isDone).toList(growable: false);

  int get hotCount =>
      activeDeadlines.where((deadline) => deadline.isUrgent).length;

  List<Deadline> get visibleDeadlines => switch (filter) {
    .hot =>
      activeDeadlines
          .where((deadline) => deadline.isUrgent)
          .toList(growable: false),
    .mine =>
      activeDeadlines
          .where((deadline) => deadline.source == .me)
          .toList(growable: false),
    .group =>
      activeDeadlines
          .where((deadline) => deadline.source != .me)
          .toList(growable: false),
    .done =>
      deadlines.where((deadline) => deadline.isDone).toList(growable: false),
    .all => deadlines,
  };

  List<Deadline> inBucket(DeadlineBucket bucket) => visibleDeadlines
      .where((deadline) => deadlineBucket(deadline) == bucket)
      .toList(growable: false);
}
