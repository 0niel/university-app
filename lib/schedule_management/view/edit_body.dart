part of 'edit_schedules_page.dart';

class _EditBody extends StatelessWidget {
  const _EditBody({required this.state});

  final ScheduleState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
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

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            16,
          ),
          child: Text(
            l10n.editSchedulesHint,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ),
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
              style: AppText.headline.copyWith(color: colors.ink),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: PrimaryScheduleCard(
              schedule: selected,
              updatedAt: state.scheduleSyncedAt[activeId] ?? state.lastSyncedAt,
            ),
          ),
          const SizedBox(height: 18),
        ],
        _ReorderableSection(
          title: l10n.scheduleHubGroupsSection,
          target: .group,
          entries: [
            for (final entry in groups)
              _EditEntry(
                id: entry.$1,
                name: entry.$2.name,
                schedule: entry.$3,
              ),
          ],
        ),
        _ReorderableSection(
          title: l10n.scheduleHubTeachersSection,
          target: .teacher,
          entries: [
            for (final entry in teachers)
              _EditEntry(
                id: entry.$1,
                name: entry.$2.name,
                schedule: entry.$3,
              ),
          ],
        ),
        _ReorderableSection(
          title: l10n.scheduleHubClassroomsSection,
          target: .classroom,
          entries: [
            for (final entry in classrooms)
              _EditEntry(
                id: entry.$1,
                name: entry.$2.name,
                schedule: entry.$3,
              ),
          ],
        ),
      ],
    );
  }
}
