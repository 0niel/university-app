import 'package:rtu_mirea_app/l10n/l10n.dart';

String relativeTime(
  AppLocalizations l10n,
  DateTime date, {
  DateTime? now,
}) {
  final diff = (now ?? DateTime.now()).difference(date.toLocal());
  if (diff.inMinutes < 1) return l10n.lostFoundJustNow;
  if (diff.inMinutes < 60) return l10n.lostFoundMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.lostFoundHoursAgo(diff.inHours);
  if (diff.inDays == 1) return l10n.marketYesterday;
  return l10n.lostFoundDaysAgo(diff.inDays);
}
