import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> confirmScheduleDeletion(
  BuildContext context, {
  required String identifier,
  required String name,
  required ScheduleTarget target,
}) async {
  final l10n = context.l10n;
  final confirmed = await showNinjaConfirmDialog(
    context,
    title: l10n.deleteSchedule,
    message: l10n.deleteScheduleConfirm(name),
    confirmLabel: l10n.delete,
    cancelLabel: l10n.cancel,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;
  context.read<ScheduleBloc>().add(
    ScheduleDeleteRequested(identifier: identifier, target: target),
  );
  NinjaToastHost.maybeOf(
    context,
  )?.show(NinjaToastData(message: l10n.scheduleRemovedToast));
}
