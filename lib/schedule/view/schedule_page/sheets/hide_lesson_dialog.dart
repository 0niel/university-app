import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showHideLessonDialog(
  BuildContext context, {
  required LessonSchedulePart lesson,
}) async {
  final l10n = context.l10n;
  final preferences = context.read<SchedulePreferencesCubit>();

  final confirmed = await showNinjaConfirmDialog(
    context,
    title: l10n.hideLessonTitle,
    message:
        '${l10n.hideLessonBody(lesson.subject)}\n'
        '${l10n.hideLessonAllSubject}',
    confirmLabel: l10n.hideLessonAction,
    cancelLabel: l10n.cancel,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;

  preferences.hideSubject(lesson.subject);
  showNinjaToast(context, showCheck: false, message: l10n.hideLessonDone);
}
