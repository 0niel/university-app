part of 'schedule_management_page.dart';

class _HubBody extends StatelessWidget {
  const _HubBody({
    required this.state,
    required this.onAdd,
    required this.onEdit,
  });

  final ScheduleState state;
  final VoidCallback onAdd;
  final VoidCallback onEdit;

  bool get _hasSaved =>
      state.groupsSchedule.isNotEmpty ||
      state.teachersSchedule.isNotEmpty ||
      state.classroomsSchedule.isNotEmpty ||
      state.selectedSchedule != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasSaved) {
      if (state.status == .loading) return const _HubSkeleton();
      if (state.status == .failure) return _HubError(onRetry: _refresh);
      return _HubEmpty(onAdd: onAdd);
    }

    final l10n = context.l10n;
    final activeId = scheduleSelectedId(state.selectedSchedule);
    final groups = [
      for (final entry in state.groupsSchedule)
        if (entry.$1 != activeId) entry,
    ];
    final teachers = [
      for (final entry in state.teachersSchedule)
        if (entry.$1 != activeId) entry,
    ];
    final classrooms = [
      for (final entry in state.classroomsSchedule)
        if (entry.$1 != activeId) entry,
    ];

    return RefreshIndicator(
      color: context.colors.ink,
      backgroundColor: context.colors.canvas,
      onRefresh: () async => _refresh(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: state.selectedSchedule == null ? AppSpacing.gap : AppSpacing.xl,
          bottom: ninjaBottomInset(context) + AppSpacing.lg,
        ),
        children: [
          if (state.selectedSchedule case final selected?) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                10,
              ),
              child: Text(
                l10n.scheduleHubPrimarySection,
                style: AppText.headline.copyWith(color: context.colors.ink),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: PrimaryScheduleCard(
                schedule: selected,
                updatedAt:
                    state.scheduleSyncedAt[activeId] ?? state.lastSyncedAt,
                onTap: () => _openSchedule(context),
              ),
            ),
            const SizedBox(height: 18),
          ],
          if (groups.isNotEmpty)
            _HubSection(
              title: l10n.scheduleHubGroupsSection,
              onEdit: onEdit,
              children: [
                for (final entry in groups)
                  ScheduleHubRow(
                    target: .group,
                    name: entry.$2.name,
                    schedule: entry.$3,
                    updatedAt: state.scheduleSyncedAt[entry.$1],
                    onTap: () => _select(
                      context,
                      SelectedGroupSchedule(
                        group: entry.$2,
                        schedule: entry.$3,
                      ),
                    ),
                  ),
              ],
            ),
          if (teachers.isNotEmpty)
            _HubSection(
              title: l10n.scheduleHubTeachersSection,
              onEdit: onEdit,
              children: [
                for (final entry in teachers)
                  ScheduleHubRow(
                    target: .teacher,
                    name: entry.$2.name,
                    schedule: entry.$3,
                    updatedAt: state.scheduleSyncedAt[entry.$1],
                    onTap: () => _select(
                      context,
                      SelectedTeacherSchedule(
                        teacher: entry.$2,
                        schedule: entry.$3,
                      ),
                    ),
                  ),
              ],
            ),
          if (classrooms.isNotEmpty)
            _HubSection(
              title: l10n.scheduleHubClassroomsSection,
              onEdit: onEdit,
              children: [
                for (final entry in classrooms)
                  ScheduleHubRow(
                    target: .classroom,
                    name: entry.$2.name,
                    schedule: entry.$3,
                    updatedAt: state.scheduleSyncedAt[entry.$1],
                    onTap: () => _select(
                      context,
                      SelectedClassroomSchedule(
                        classroom: entry.$2,
                        schedule: entry.$3,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _select(BuildContext context, SelectedSchedule schedule) {
    context.read<ScheduleBloc>().add(
      ScheduleSelected(selectedSchedule: schedule),
    );
    _openSchedule(context);
  }

  void _openSchedule(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
    GoRouter.of(context).go('/schedule');
  }

  void _refresh(BuildContext context) {
    context.read<ScheduleBloc>().add(
      const SelectedScheduleRefreshRequested(manual: true),
    );
  }
}
