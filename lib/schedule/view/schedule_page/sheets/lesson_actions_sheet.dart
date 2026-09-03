import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showLessonActionsSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
}) {
  final l10n = context.l10n;
  final navigator = Navigator.of(context, rootNavigator: true);
  void run(VoidCallback action) {
    navigator.pop();
    if (context.mounted) action();
  }

  return showAppSheet<void>(
    context,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              key: const ValueKey('lesson-actions-type'),
              width: AppControlSize.touchTarget,
              height: AppControlSize.touchTarget,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: lessonTintOf(context, lesson),
                borderRadius: BorderRadius.circular(AppRadius.tile),
              ),
              child: Text(
                lessonShortLabel(l10n, lesson.lessonType),
                style: AppText.sans(
                  10,
                  FontWeight.w800,
                ).copyWith(color: lessonAccentOf(context, lesson)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      16,
                      FontWeight.w700,
                    ).copyWith(color: context.colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${timeRangeText(lesson)} · '
                    '${singleClassroomText(l10n, lesson)}',
                    style: AppText.sans(
                      12.5,
                      FontWeight.w400,
                    ).copyWith(color: context.colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppListGroup(
          children: [
            AppListRow(
              title: l10n.scheduleActionOpen,
              leading: const AppLineIconWidget(AppLineIcon.info),
              strong: true,
              showChevron: false,
              onTap: () => run(
                () => ScheduleDetailsRoute(
                  $extra: (lesson, day),
                ).push<void>(context),
              ),
            ),
            AppListRow(
              title: l10n.classActionRemind,
              leading: const AppLineIconWidget(AppLineIcon.bell),
              strong: true,
              showChevron: false,
              onTap: () => run(
                () => showLessonRemindSheet(context, lesson: lesson, day: day),
              ),
            ),
            AppListRow(
              title: l10n.noteEditorTitle,
              leading: const AppLineIconWidget(AppLineIcon.pencil),
              strong: true,
              showChevron: false,
              onTap: () => run(
                () => showLessonNoteSheet(context, lesson: lesson, day: day),
              ),
            ),
            AppListRow(
              title: l10n.classActionShare,
              leading: const AppLineIconWidget(AppLineIcon.share),
              strong: true,
              showChevron: false,
              onTap: () => run(
                () => showScheduleShareSheet(context, lesson: lesson, day: day),
              ),
            ),
            AppListRow(
              title: l10n.scheduleActionHide,
              leading: const AppLineIconWidget(AppLineIcon.hide),
              strong: true,
              showChevron: false,
              onTap: () => run(() {
                final preferences = context.read<SchedulePreferencesCubit>()
                  ..hideSubject(lesson.subject);
                ToastManager.showInfo(
                  context,
                  message: l10n.scheduleLessonHidden,
                  actionLabel: l10n.filtersRestore,
                  onAction: () => preferences.unhideSubject(lesson.subject),
                );
              }),
            ),
            AppListRow(
              title: l10n.scheduleActionReport,
              leading: const AppLineIconWidget(AppLineIcon.alert),
              strong: true,
              destructive: true,
              showChevron: false,
              onTap: () => run(() async {
                final config = context.read<UniversityConfig>();
                final uri = Uri(
                  scheme: 'mailto',
                  path: config.supportEmail,
                  queryParameters: {
                    'subject':
                        '${l10n.scheduleActionReport}: ${lesson.subject}',
                    'body':
                        '${day.toIso8601String()}\n'
                        '${lessonMetaText(l10n, lesson)}',
                  },
                );
                if (!await launchUrl(uri) && context.mounted) {
                  ToastManager.showError(
                    context,
                    message: l10n.scheduleActionFailed,
                  );
                }
              }),
            ),
          ],
        ),
      ],
    ),
  );
}
