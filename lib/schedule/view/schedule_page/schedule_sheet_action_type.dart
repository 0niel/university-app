part of '../schedule_page.dart';

enum _ScheduleSheetActionType {
  schedules,
  customSchedules,
  changes,
  session,
  compare,
  analytics,
  export,
  filters,
}

Future<void> _showScheduleMoreActions(
  BuildContext context, {
  required String scheduleName,
}) async {
  final l10n = context.l10n;

  final important = [
    _ScheduleSheetAction(
      type: .changes,
      icon: .refresh,
      title: l10n.changesTitle,
      subtitle: l10n.changesSubtitle,
    ),
    _ScheduleSheetAction(
      type: .session,
      icon: .trophy,
      title: l10n.sessionTitle,
      subtitle: l10n.sessionSubtitle,
    ),
  ];
  final tools = [
    _ScheduleSheetAction(
      type: .compare,
      icon: .people,
      title: l10n.compareTitle,
      subtitle: l10n.compareSubtitle,
    ),
    _ScheduleSheetAction(
      type: .analytics,
      icon: .chart,
      title: l10n.analyticsTitle,
      subtitle: l10n.analyticsSubtitle,
    ),
  ];
  final settings = [
    _ScheduleSheetAction(
      type: .export,
      icon: .download,
      title: l10n.exportScheduleTitle,
      subtitle: l10n.exportScheduleSubtitle,
    ),
    _ScheduleSheetAction(
      type: .filters,
      icon: .filter,
      title: l10n.filtersTitle,
      subtitle: l10n.filtersSubtitle,
    ),
  ];

  final action = await showAppSheet<_ScheduleSheetActionType>(
    context,
    title: l10n.scheduleActionsTitle,
    subtitle: scheduleName,
    backgroundColor: context.ninja.canvas,
    contentPadding: EdgeInsets.zero,
    child: _ScheduleActionsMenu(
      schedules: _ScheduleSheetAction(
        type: .schedules,
        icon: .calendar,
        title: l10n.scheduleHubAllSchedules,
        subtitle: l10n.scheduleHubAllSchedulesSubtitle,
      ),
      customSchedules: _ScheduleSheetAction(
        type: .customSchedules,
        icon: .plus,
        title: l10n.mySchedules,
        subtitle: l10n.mySchedulesSubtitle,
      ),
      importantLabel: l10n.scheduleActionsImportant,
      important: important,
      toolsLabel: l10n.scheduleActionsTools,
      tools: tools,
      settingsLabel: l10n.scheduleActionsSettings,
      settings: settings,
    ),
  );
  if (action == null || !context.mounted) return;
  switch (action) {
    case .schedules:
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => const ScheduleManagementPage(),
        ),
      );
    case .customSchedules:
      context.go('/schedule/custom');
    case .changes:
      context.go('/schedule/changes');
    case .session:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SessionPage()),
      );
    case .compare:
      context.go('/schedule/compare');
    case .analytics:
      context.go('/schedule/analytics');
    case .export:
      await showScheduleExportSheet(context);
    case .filters:
      await showScheduleFilterSheet(context);
  }
}

class _ScheduleSheetAction {
  const _ScheduleSheetAction({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final _ScheduleSheetActionType type;
  final AppLineIcon icon;
  final String title;
  final String subtitle;
}

class _ScheduleActionsMenu extends StatelessWidget {
  const _ScheduleActionsMenu({
    required this.schedules,
    required this.customSchedules,
    required this.importantLabel,
    required this.important,
    required this.toolsLabel,
    required this.tools,
    required this.settingsLabel,
    required this.settings,
  });

  final _ScheduleSheetAction schedules;
  final _ScheduleSheetAction customSchedules;
  final String importantLabel;
  final List<_ScheduleSheetAction> important;
  final String toolsLabel;
  final List<_ScheduleSheetAction> tools;
  final String settingsLabel;
  final List<_ScheduleSheetAction> settings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          _SchedulePrimaryActions(
            schedules: schedules,
            customSchedules: customSchedules,
          ),
          const SizedBox(height: 24),
          _ScheduleActionsSection(label: importantLabel, actions: important),
          const SizedBox(height: 20),
          _ScheduleActionsSection(label: toolsLabel, actions: tools),
          const SizedBox(height: 20),
          _ScheduleActionsSection(label: settingsLabel, actions: settings),
        ],
      ),
    );
  }
}

class _SchedulePrimaryActions extends StatelessWidget {
  const _SchedulePrimaryActions({
    required this.schedules,
    required this.customSchedules,
  });

  final _ScheduleSheetAction schedules;
  final _ScheduleSheetAction customSchedules;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 340 || textScale >= 1.6;
        final schedulesCard = _SchedulePrimaryActionCard(
          key: const ValueKey('schedule-actions-all'),
          action: schedules,
          primary: true,
        );
        final customSchedulesCard = _SchedulePrimaryActionCard(
          key: const ValueKey('schedule-actions-custom'),
          action: customSchedules,
          primary: false,
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              schedulesCard,
              const SizedBox(height: 10),
              customSchedulesCard,
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(child: schedulesCard),
              const SizedBox(width: 10),
              Expanded(child: customSchedulesCard),
            ],
          ),
        );
      },
    );
  }
}

class _SchedulePrimaryActionCard extends StatelessWidget {
  const _SchedulePrimaryActionCard({
    required this.action,
    required this.primary,
    super.key,
  });

  final _ScheduleSheetAction action;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final foreground = primary ? colors.onBrand : colors.ink;
    final secondary = primary
        ? colors.onBrand.withValues(alpha: .76)
        : colors.mutedDark;
    final iconBackground = primary
        ? colors.onBrand.withValues(alpha: .16)
        : colors.brand.withValues(alpha: colors.isDark ? .2 : .1);
    return AppPressable(
      pressedScale: .98,
      semanticsLabel: '${action.title}. ${action.subtitle}',
      semanticsButton: true,
      onTap: () => Navigator.of(context).pop(action.type),
      child: Container(
        constraints: const BoxConstraints(minHeight: 116),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: primary ? colors.brand : colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 38,
                    child: Center(
                      child: AppLineIconWidget(
                        action.icon,
                        size: 18,
                        color: primary ? colors.onBrand : colors.brandInk,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                AppLineIconWidget(.chevronR, size: 16, color: secondary),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              action.title,
              style: NinjaText.body.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              action.subtitle,
              style: NinjaText.subtext.copyWith(
                fontSize: 12,
                height: 1.25,
                color: secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleActionsSection extends StatelessWidget {
  const _ScheduleActionsSection({
    required this.label,
    required this.actions,
  });

  final String label;
  final List<_ScheduleSheetAction> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .only(left: 2, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: NinjaText.microLabel.copyWith(color: colors.muted),
          ),
        ),
        ClipRRect(
          borderRadius: .circular(NinjaRadius.control),
          child: ColoredBox(
            color: colors.surfaceAlt,
            child: Column(
              children: [
                for (final (index, action) in actions.indexed) ...[
                  _ScheduleActionTile(action: action),
                  if (index != actions.length - 1)
                    Container(
                      height: 1,
                      margin: const .only(left: 64, right: 12),
                      color: colors.line,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleActionTile extends StatelessWidget {
  const _ScheduleActionTile({required this.action});

  final _ScheduleSheetAction action;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      semanticsLabel: '${action.title}. ${action.subtitle}',
      semanticsButton: true,
      onTap: () => Navigator.of(context).pop(action.type),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        child: Padding(
          padding: const .symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.brand.withValues(
                    alpha: colors.isDark ? .2 : .1,
                  ),
                  borderRadius: .circular(12),
                ),
                child: SizedBox.square(
                  dimension: 40,
                  child: Center(
                    child: AppLineIconWidget(
                      action.icon,
                      size: 18,
                      color: colors.brandInk,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      action.title,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: NinjaText.subtext.copyWith(
                        fontSize: 12.5,
                        height: 1.28,
                        color: colors.mutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppLineIconWidget(
                .chevronR,
                size: 15,
                color: colors.chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
