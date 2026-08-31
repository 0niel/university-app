import 'package:rtu_mirea_app/l10n/l10n.dart';

String feedMetaLine(
  AppLocalizations l10n, {
  String? categoryName,
  DateTime? publishedAt,
}) {
  final parts = <String>[
    if (categoryName != null && categoryName.trim().isNotEmpty)
      categoryName.trim(),
    if (publishedAt != null) feedRelativeTime(l10n, publishedAt),
  ];
  return parts.join(' · ');
}

String feedRelativeTime(AppLocalizations l10n, DateTime date) {
  final diff = DateTime.now().difference(date.toLocal());
  if (diff.inMinutes < 1) return l10n.lostFoundJustNow;
  if (diff.inMinutes < 60) return l10n.lostFoundMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.lostFoundHoursAgo(diff.inHours);
  return l10n.lostFoundDaysAgo(diff.inDays);
}
