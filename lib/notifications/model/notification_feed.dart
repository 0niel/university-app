import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_presentation.dart';
import 'package:schedule_repository/schedule_repository.dart';

String scheduleChangeNotificationId(ScheduleChange change) =>
    'change:${change.id}';

AppNotificationKind scheduleChangeKindOf(ScheduleChangeKind kind) =>
    switch (kind) {
      ScheduleChangeKind.cancel => AppNotificationKind.danger,
      ScheduleChangeKind.add => AppNotificationKind.lecture,
      ScheduleChangeKind.move ||
      ScheduleChangeKind.room ||
      ScheduleChangeKind.teacher ||
      ScheduleChangeKind.update => AppNotificationKind.warn,
    };

List<AppNotification> buildNotificationFeed({
  required AppLocalizations l10n,
  required List<AppNotification> pushes,
  required List<ScheduleChange> changes,
  DateTime? now,
}) {
  return [
    ...pushes,
    for (final change in changes) _scheduleNotification(l10n, change),
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

AppNotification _scheduleNotification(
  AppLocalizations l10n,
  ScheduleChange change,
) {
  final presentation = ScheduleChangePresentation.fromChange(change, l10n);
  return AppNotification(
    id: scheduleChangeNotificationId(change),
    kind: scheduleChangeKindOf(presentation.effectiveKind),
    title: '${presentation.subject} · ${presentation.title}',
    subtitle: presentation.summary,
    route: '/schedule',
    createdAt: change.createdAt,
  );
}

String notificationAgeLabel(
  AppLocalizations l10n,
  DateTime createdAt, {
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final delta = current.difference(createdAt);
  if (delta.inMinutes < 1) return l10n.notifTimeNow;
  if (delta.inMinutes < 60) return l10n.notifTimeMinutes(delta.inMinutes);
  if (delta.inHours < 24) return l10n.notifTimeHours(delta.inHours);
  final today = DateTime(current.year, current.month, current.day);
  final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
  if (today.difference(day).inDays == 1) return l10n.notifTimeYesterday;
  return DateFormat('d MMM', l10n.localeName).format(createdAt);
}
