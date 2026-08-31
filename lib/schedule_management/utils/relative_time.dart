import 'package:rtu_mirea_app/l10n/l10n.dart';

String scheduleUpdatedAgo(AppLocalizations l10n, DateTime date) {
  final diff = DateTime.now().difference(date.toLocal());
  final phrase = diff.inMinutes < 1
      ? l10n.lostFoundJustNow
      : diff.inMinutes < 60
      ? l10n.lostFoundMinutesAgo(diff.inMinutes)
      : diff.inHours < 24
      ? l10n.lostFoundHoursAgo(diff.inHours)
      : l10n.lostFoundDaysAgo(diff.inDays);
  return l10n.scheduleHubUpdatedAgo(phrase);
}

String scheduleUpdatedShort(AppLocalizations l10n, DateTime date) {
  final diff = DateTime.now().difference(date.toLocal());
  if (diff.inMinutes < 1) return l10n.scheduleHubAgoNow;
  if (diff.inMinutes < 60) return l10n.scheduleHubAgoMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l10n.scheduleHubAgoHours(diff.inHours);
  return l10n.scheduleHubAgoDays(diff.inDays);
}
