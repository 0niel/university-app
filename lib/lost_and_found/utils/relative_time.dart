import 'package:rtu_mirea_app/l10n/l10n.dart';

String relativeTime(
  AppLocalizations l10n,
  DateTime date, {
  bool compact = false,
}) {
  final diff = DateTime.now().difference(date.toLocal());
  if (compact) {
    if (diff.inMinutes < 1) return l10n.newsTimeNow;
    if (diff.inMinutes < 60) return l10n.newsTimeMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.newsTimeHours(diff.inHours);
    if (diff.inDays == 1) return l10n.newsTimeYesterday;
    return l10n.newsTimeDays(diff.inDays);
  }
  if (diff.inMinutes < 1) return l10n.lostFoundJustNow;
  if (diff.inMinutes < 60) return l10n.lostFoundMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.lostFoundHoursAgo(diff.inHours);
  return l10n.lostFoundDaysAgo(diff.inDays);
}
