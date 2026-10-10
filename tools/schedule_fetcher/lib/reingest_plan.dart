/// Picks which unchanged targets a full sync should re-ingest this run.
///
/// Re-ingesting every target at once (the old daily "full reingest") takes
/// ~1300 ingest batches and has taken the production database down. Instead
/// each run re-ingests a bounded slice of the targets in sorted-key order,
/// resuming from the cursor stored in the sync checkpoint; a whole cycle over
/// the target list is what "full reingest" now means.
class ReingestPlan {
  const ReingestPlan({
    required this.due,
    required this.nextCursor,
    required this.wrapped,
  });

  /// Target keys (`type:id`) to re-ingest even when their source hash matches
  /// the checkpoint.
  final Set<String> due;

  /// Cursor to store for the next run: the last key in [due], or empty once
  /// the cycle completed.
  final String nextCursor;

  /// True when this slice reaches the end of the target list, i.e. every
  /// target has been re-ingested since the cursor last wrapped.
  final bool wrapped;
}

ReingestPlan planUnchangedReingest({
  required Iterable<String> targetKeys,
  required String cursor,
  required int budget,
}) {
  if (budget <= 0) {
    return const ReingestPlan(due: {}, nextCursor: '', wrapped: false);
  }
  final sorted = targetKeys.toSet().toList()..sort();
  final remaining = sorted.where((key) => key.compareTo(cursor) > 0).toList();
  final wrapped = remaining.length <= budget;
  final due = wrapped ? remaining : remaining.sublist(0, budget);
  return ReingestPlan(
    due: due.toSet(),
    nextCursor: wrapped || due.isEmpty ? '' : due.last,
    wrapped: wrapped,
  );
}
