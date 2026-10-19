import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';

Future<void> showPreviewLesson(BuildContext context, HomeLessonEntry entry) =>
    showAppSheet<void>(
      context,
      title: entry.lesson.subject,
      child: AppLessonCard(
        title: entry.lesson.subject,
        time: DateFormat.Hm().format(entry.start),
        endTime: DateFormat.Hm().format(entry.end),
        color: lessonAccentOf(context, entry.lesson),
        location: entry.room,
        meta: homeLessonMeta(context.l10n, entry),
        typeLabel: lessonShortLabel(context.l10n, entry.lesson.lessonType),
      ),
    );
