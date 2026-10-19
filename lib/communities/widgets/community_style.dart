import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/painting.dart';
import 'package:rtu_mirea_app/communities/widgets/community_platform.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Color communityTone(AppColors colors, String seed) {
  final palette = [
    colors.accent,
    colors.lecture,
    colors.practice,
    colors.lab,
    colors.exam,
  ];
  var hash = 7;
  for (final unit in seed.codeUnits) {
    hash = (hash * 31 + unit) & 0xffffff;
  }
  return palette.elementAtOrNull(hash % palette.length) ?? colors.accent;
}

String communityAbbreviation(String name) {
  final acronym = RegExp('^[A-ZА-ЯЁ]{2,}').firstMatch(name.trim());
  if (acronym != null) return acronym.group(0)!.substring(0, 2);
  return AppAvatar.initialsOf(name);
}

Color communityCategoryTone(AppColors colors, String category) =>
    switch (category.trim().toLowerCase()) {
      'it' || 'ит' => colors.practice,
      'учёба' || 'учеба' || 'study' => colors.lab,
      'спорт' || 'sports' || 'волонтёрство' || 'volunteering' => colors.lecture,
      'творчество' || 'creative' => colors.exam,
      _ => communityTone(colors, category),
    };

CommunityPlatform communityPlatformOf(CommunityCatalogEntry entry) {
  final uri = safeCommunityUri(entry.url);
  return uri == null ? CommunityPlatform.web : communityPlatformFor(uri);
}

String communityPlatformLabel(
  AppLocalizations l10n,
  CommunityCatalogEntry entry,
) => switch (communityPlatformOf(entry)) {
  CommunityPlatform.telegram => 'Telegram',
  CommunityPlatform.vk => 'VK',
  CommunityPlatform.discord => 'Discord',
  CommunityPlatform.web => l10n.communityPlatformWeb,
};

String communityMembers(
  AppLocalizations l10n,
  CommunityCatalogEntry entry,
) {
  final count = entry.membersCount;
  if (count == null) return communityPlatformLabel(l10n, entry);
  return l10n.communitiesMembersCount('$count');
}

String communityMeta(
  AppLocalizations l10n,
  CommunityCatalogEntry entry, {
  required String categoryTitle,
}) {
  final count = entry.membersCount;
  final parts = <String>[
    if (categoryTitle.trim().isNotEmpty) categoryTitle.trim(),
    if (count != null)
      communityMembers(l10n, entry)
    else
      communityPlatformLabel(l10n, entry),
  ];
  return parts.join(' · ');
}

String? communityHandle(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) return null;
  final handle = segments.lastOrNull?.replaceFirst('@', '').trim() ?? '';
  return handle.isEmpty ? null : handle.toLowerCase();
}
