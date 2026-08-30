part of 'add_schedule_page.dart';

class _AddScheduleResultsSkeleton extends StatelessWidget {
  const _AddScheduleResultsSkeleton();

  static const int _rows = 5;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: List.generate(
          _rows,
          (_) => const _AddScheduleRowSkeleton(),
        ),
      ),
    );
  }
}
