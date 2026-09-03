import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

String teamKindLabel(AppLocalizations l10n, String key) => switch (key) {
  'hackathon' => l10n.teamFinderKindHackathon,
  'project' => l10n.teamFinderKindProject,
  'study' => l10n.teamFinderKindStudy,
  _ => humanizeTeamKey(key),
};

String teamKindFilterLabel(AppLocalizations l10n, String key) => switch (key) {
  'hackathon' => l10n.teamFinderFilterHackathons,
  'project' => l10n.teamFinderFilterProjects,
  'study' => l10n.teamFinderFilterStudy,
  _ => teamKindLabel(l10n, key),
};

String teamRoleLabel(AppLocalizations l10n, String key) => switch (key) {
  'frontend' => l10n.teamFinderRoleFrontend,
  'ml' => l10n.teamFinderRoleMl,
  'design' => l10n.teamFinderRoleDesign,
  'backend' => l10n.teamFinderRoleBackend,
  'marketing' => l10n.teamFinderRoleMarketing,
  _ => humanizeTeamKey(key),
};

String formatTeamDate(BuildContext context, DateTime date) => DateFormat(
  'd MMMM',
  Localizations.localeOf(context).toLanguageTag(),
).format(date.toLocal());

String teamRelativeTime(AppLocalizations l10n, DateTime? date) {
  if (date == null) return '';
  final difference = DateTime.now().difference(date.toLocal());
  if (difference.inMinutes < 1) return l10n.lostFoundJustNow;
  if (difference.inMinutes < 60) {
    return l10n.groupSpaceTimeMinutes(difference.inMinutes);
  }
  if (difference.inHours < 24) {
    return l10n.groupSpaceTimeHours(difference.inHours);
  }
  return l10n.groupSpaceTimeDays(difference.inDays);
}

String humanizeTeamKey(String key) => key
    .split(RegExp('[_-]+'))
    .where((part) => part.isNotEmpty)
    .map((part) => '${part.substring(0, 1).toUpperCase()}${part.substring(1)}')
    .join(' ');

List<String> parseCustomRoles(String input) => {
  for (final part in input.split(','))
    if (part.trim().isNotEmpty) part.trim(),
}.toList(growable: false);
