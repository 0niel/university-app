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
  if (diff.inMinutes < 1) return l10n.newsTimeNow;
  if (diff.inMinutes < 60) return l10n.newsTimeMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l10n.newsTimeHours(diff.inHours);
  if (diff.inDays < 2) return l10n.newsTimeYesterday;
  return l10n.newsTimeDays(diff.inDays);
}

String feedAbbreviation(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  final letters = words.take(2).map((word) => word[0].toUpperCase()).join();
  if (letters.length >= 2) return letters;
  final compact = name.replaceAll(RegExp(r'\s+'), '');
  if (compact.length >= 2) return compact.substring(0, 2).toUpperCase();
  return compact.isEmpty ? '?' : compact.toUpperCase();
}
