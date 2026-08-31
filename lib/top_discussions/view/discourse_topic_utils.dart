import 'dart:async';

import 'package:community_repository/community_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

String topicTimeAgo(AppLocalizations l10n, DateTime? posted) {
  if (posted == null) return '';
  final diff = DateTime.now().difference(posted);
  if (diff.inDays > 0) return l10n.daysAgo(diff.inDays);
  if (diff.inHours > 0) return l10n.hoursAgo(diff.inHours);
  if (diff.inMinutes > 0) return l10n.minutesAgo(diff.inMinutes);
  return l10n.justNow;
}

void openDiscourseTopic(String forumUrl, int id) {
  unawaited(
    launchUrlString(
      Uri.parse(forumUrl).resolve('t/$id').toString(),
      mode: .externalApplication,
    ),
  );
}

void openDiscourseTop(String forumUrl) {
  unawaited(
    launchUrlString(
      Uri.parse(forumUrl).resolve('top').toString(),
      mode: .externalApplication,
    ),
  );
}

String discourseAvatarUrl(String forumUrl, DiscourseUser? user) {
  final template = user?.avatarTemplate;
  if (template == null || template.isEmpty) {
    return Uri.parse(
      forumUrl,
    ).resolve('letter_avatar_proxy/v4/letter/u/5f9b8f/48.png').toString();
  }
  return Uri.parse(
    forumUrl,
  ).resolve(template.replaceAll('{size}', '48')).toString();
}

String? discourseImageUrl(String forumUrl, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) return null;
  return Uri.parse(forumUrl).resolve(imageUrl).toString();
}
