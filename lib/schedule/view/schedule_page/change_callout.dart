part of '../schedule_page.dart';

({String label, Color color}) _changeChip(
  AppLocalizations l10n,
  NinjaColors colors,
  ScheduleChange change,
) {
  return switch (change.kind) {
    .cancel => (label: l10n.calloutCancelled, color: colors.scarlet),
    .move => (
      label: l10n.calloutMoved(change.oldValue.start ?? '—'),
      color: colors.amberInk,
    ),
    .room => (
      label: l10n.calloutRoomChanged(change.oldValue.rooms.join(', ')),
      color: colors.amberInk,
    ),
    .teacher => (
      label: l10n.calloutTeacherChanged(change.oldValue.teachers.join(', ')),
      color: colors.amberInk,
    ),
    .add => (label: l10n.calloutAdded, color: colors.green),
  };
}
