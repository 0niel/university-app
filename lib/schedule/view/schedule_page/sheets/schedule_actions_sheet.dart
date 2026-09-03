import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/add_lesson_sheet.dart';
import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';

enum ScheduleAction {
  addLesson,
  customSchedules,
  session,
  compare,
  analytics,
}

Future<void> openScheduleSearch(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(builder: (_) => const AddSchedulePage()),
    );

Future<void> showScheduleActionsSheet(
  BuildContext context, {
  required DateTime day,
  String? scheduleName,
}) async {
  final action = await showAppSheet<ScheduleAction>(
    context,
    title: context.l10n.scheduleActionsTitle,
    subtitle: scheduleName,
    child: Builder(
      builder: (sheetContext) => ScheduleActionsMenu(
        onSelected: (action) => Navigator.of(sheetContext).pop(action),
      ),
    ),
  );
  if (action == null || !context.mounted) return;
  await performScheduleAction(context, action, day: day);
}

Future<void> performScheduleAction(
  BuildContext context,
  ScheduleAction action, {
  required DateTime day,
}) async {
  switch (action) {
    case ScheduleAction.addLesson:
      await showAddLessonSheet(context, day: day);
    case ScheduleAction.customSchedules:
      await const CustomScheduleRoute().push<void>(context);
    case ScheduleAction.session:
      await const ScheduleSessionRoute().push<void>(context);
    case ScheduleAction.compare:
      await const ScheduleCompareRoute().push<void>(context);
    case ScheduleAction.analytics:
      await const ScheduleAnalyticsRoute().push<void>(context);
  }
}

class ScheduleActionsMenu extends StatelessWidget {
  const ScheduleActionsMenu({required this.onSelected, super.key});

  final ValueChanged<ScheduleAction> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget row(
      ScheduleAction action,
      AppLineIcon icon,
      String title,
      String subtitle,
    ) => AppListRow(
      key: ValueKey('schedule-action-${action.name}'),
      title: title,
      subtitle: subtitle,
      leading: AppLineIconWidget(icon),
      strong: true,
      onTap: () => onSelected(action),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppListGroup(
          children: [
            row(
              ScheduleAction.addLesson,
              AppLineIcon.plus,
              l10n.customSchedulesAddLesson,
              l10n.scheduleAddSubtitle,
            ),
            row(
              ScheduleAction.customSchedules,
              AppLineIcon.calendar,
              l10n.mySchedules,
              l10n.mySchedulesSubtitle,
            ),
          ],
        ),
        AppOverline(l10n.scheduleActionsImportant),
        AppListGroup(
          children: [
            row(
              ScheduleAction.session,
              AppLineIcon.trophy,
              l10n.sessionTitle,
              l10n.sessionSubtitle,
            ),
          ],
        ),
        AppOverline(l10n.scheduleActionsTools),
        AppListGroup(
          children: [
            row(
              ScheduleAction.compare,
              AppLineIcon.people,
              l10n.compareTitle,
              l10n.compareSubtitle,
            ),
            row(
              ScheduleAction.analytics,
              AppLineIcon.chart,
              l10n.analyticsTitle,
              l10n.analyticsSubtitle,
            ),
          ],
        ),
      ],
    );
  }
}
