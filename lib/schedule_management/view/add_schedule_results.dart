part of 'add_schedule_page.dart';

class _AddScheduleResults extends StatelessWidget {
  const _AddScheduleResults({required this.target, required this.onRetry});

  final ScheduleTarget target;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, search) {
        final results = _resultsFor(search);
        if (results.isEmpty) {
          if (search.status == .loading) {
            return const _AddScheduleResultsSkeleton();
          }
          if (search.status == .failure) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              children: [
                AppErrorState(
                  title: l10n.searchFailed,
                  message: l10n.tryAgain,
                  primaryLabel: l10n.retry,
                  footnote: null,
                  onPrimary: onRetry,
                ),
                const SizedBox(height: AppSpacing.lg),
                _CreateScheduleRow(onTap: () => _openCreate(context)),
              ],
            );
          }
          return _EmptyScheduleResults(onCreate: () => _openCreate(context));
        }

        final scheduleState = context.watch<ScheduleBloc>().state;
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                10,
              ),
              child: Text(
                l10n.addScheduleFound(results.length),
                style: AppText.headline.copyWith(color: colors.ink),
              ),
            ),
            for (final result in results)
              _AddScheduleResultRow(
                key: ValueKey('${result.target.name}:${result.id}'),
                result: result,
                added: result.isAdded(scheduleState),
              ),
            const SizedBox(height: 18),
            _CreateScheduleRow(onTap: () => _openCreate(context)),
          ],
        );
      },
    );
  }

  List<_AddScheduleResult> _resultsFor(SearchState search) => switch (target) {
    .group => [for (final group in search.groups.results) .group(group)],
    .teacher => [
      for (final teacher in search.teachers.results) .teacher(teacher),
    ],
    .classroom => [
      for (final classroom in search.classrooms.results) .classroom(classroom),
    ],
  };

  void _openCreate(BuildContext context) {
    Navigator.of(context).pop();
    GoRouter.of(context).go('/schedule/create');
  }
}

class _AddScheduleResult {
  _AddScheduleResult.group(Group group)
    : target = .group,
      name = group.name,
      id = group.uid ?? group.name,
      subtitle = null,
      onSubscribe = ((bloc) =>
          bloc.add(ScheduleRequested(group: group, makeActive: false)));

  _AddScheduleResult.teacher(Teacher teacher)
    : target = .teacher,
      name = teacher.name,
      id = teacher.uid ?? teacher.name,
      subtitle = teacher.post ?? teacher.department,
      onSubscribe = ((bloc) => bloc.add(
        TeacherScheduleRequested(teacher: teacher, makeActive: false),
      ));

  _AddScheduleResult.classroom(Classroom classroom)
    : target = .classroom,
      name = classroom.name,
      id = classroom.uid ?? classroom.name,
      subtitle = classroom.campus?.shortName ?? classroom.campus?.name,
      onSubscribe = ((bloc) => bloc.add(
        ClassroomScheduleRequested(classroom: classroom, makeActive: false),
      ));

  final ScheduleTarget target;
  final String name;
  final String id;
  final String? subtitle;
  final void Function(ScheduleBloc bloc) onSubscribe;

  bool isAdded(ScheduleState state) => switch (target) {
    .group => state.groupsSchedule.any((entry) => entry.$1 == id),
    .teacher => state.teachersSchedule.any((entry) => entry.$1 == id),
    .classroom => state.classroomsSchedule.any((entry) => entry.$1 == id),
  };
}
