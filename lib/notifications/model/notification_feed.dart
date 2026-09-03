import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:schedule_repository/schedule_repository.dart';

String scheduleChangeNotificationId(ScheduleChange change) =>
    'change:${change.id}';

AppNotificationKind scheduleChangeKindOf(ScheduleChangeKind kind) =>
    switch (kind) {
      ScheduleChangeKind.cancel => AppNotificationKind.danger,
      ScheduleChangeKind.add => AppNotificationKind.lecture,
      ScheduleChangeKind.move ||
      ScheduleChangeKind.room ||
      ScheduleChangeKind.teacher => AppNotificationKind.warn,
    };

List<AppNotification> buildNotificationFeed({
  required AppLocalizations l10n,
  required List<AppNotification> pushes,
  required List<ScheduleChange> changes,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  return [
    ...pushes,
    for (final change in changes)
      AppNotification(
        id: scheduleChangeNotificationId(change),
        kind: scheduleChangeKindOf(change.kind),
        title: _changeTitle(l10n, change),
        subtitle: _changeSubtitle(l10n, change, today),
        route: '/schedule',
        createdAt: change.createdAt,
      ),
  ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

String _changeTitle(AppLocalizations l10n, ScheduleChange change) =>
    switch (change.kind) {
      ScheduleChangeKind.move => l10n.notifChangeMoved(change.subject),
      ScheduleChangeKind.cancel => l10n.notifChangeCancelled(change.subject),
      ScheduleChangeKind.add => l10n.notifChangeAdded(change.subject),
      ScheduleChangeKind.room => l10n.notifChangeRoom(change.subject),
      ScheduleChangeKind.teacher => l10n.notifChangeTeacher(change.subject),
    };

String _changeSubtitle(
  AppLocalizations l10n,
  ScheduleChange change,
  DateTime now,
) {
  final start = change.newValue.start ?? change.oldValue.start;
  final when = [
    _dayLabel(l10n, change.lessonDate, now),
    ?start,
  ].join(', ');
  final detail = switch (change.kind) {
    ScheduleChangeKind.move => _insteadOf(l10n, change.oldValue.start),
    ScheduleChangeKind.room => [
      change.newValue.rooms.join(', '),
      _insteadOf(l10n, change.oldValue.rooms.join(', ')),
    ].where((part) => part.isNotEmpty).join(' · '),
    ScheduleChangeKind.teacher => change.newValue.teachers.join(', '),
    ScheduleChangeKind.add => change.newValue.rooms.join(', '),
    ScheduleChangeKind.cancel => '',
  };
  return [when, detail].where((part) => part.isNotEmpty).join(' · ');
}

String _insteadOf(AppLocalizations l10n, String? value) =>
    value == null || value.isEmpty ? '' : l10n.notifChangeInsteadOf(value);

String _dayLabel(AppLocalizations l10n, DateTime date, DateTime now) {
  final day = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  final delta = day.difference(today).inDays;
  if (delta == 0) return l10n.today;
  if (delta == 1) return l10n.pickerTomorrow;
  return DateFormat('d MMM', l10n.localeName).format(date);
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
