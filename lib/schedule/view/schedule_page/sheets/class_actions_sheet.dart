import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/hide_lesson_dialog.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/lesson_reminder_sheet.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/reaction_sheet.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/widgets/schedule_sheet_widgets.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:share_launcher/share_launcher.dart';

Future<void> showClassActionsSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
}) {
  final colors = context.ninja;
  final l10n = context.l10n;

  return showAppSheet<void>(
    context,
    title: l10n.classActionsTitle,
    backgroundColor: colors.canvas,
    contentPadding: EdgeInsets.zero,
    child: Column(
      mainAxisSize: .min,
      children: [
        NinjaLessonRow(
          title: lesson.subject,
          time: timeRangeText(lesson),
          meta: LessonCard.getLessonTypeName(
            l10n,
            lesson.lessonType,
          ).toLowerCase(),
          color: subjectColorOf(colors, lesson),
        ),
        LessonFactsStrip(lesson: lesson),
        NinjaListCell(
          title: l10n.classActionRate,
          trailingLabel: l10n.classActionRateSub,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(showReactionSheet(context, lesson: lesson, day: day));
          },
        ),
        NinjaListCell(
          title: l10n.classActionNote,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            context.go('/schedule/details', extra: (lesson, day));
          },
        ),
        NinjaListCell(
          title: l10n.classActionRoute,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            context.go('/services/map');
          },
        ),
        NinjaListCell(
          title: l10n.classActionRemind,
          trailingLabel: l10n.classActionRemindSub,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(
              showLessonReminderSheet(context, lesson: lesson, day: day),
            );
          },
        ),
        NinjaListCell(
          title: l10n.classActionShare,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(
              const ShareLauncher().share(
                text:
                    '${lesson.subject} · ${timeRangeText(lesson)}'
                    ' · ${singleClassroomText(l10n, lesson)}',
              ),
            );
          },
        ),
        NinjaListCell(
          title: l10n.classActionHide,
          showDivider: false,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            unawaited(showHideLessonDialog(context, lesson: lesson));
          },
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
