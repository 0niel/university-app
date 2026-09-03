import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorCard extends StatelessWidget {
  const ContributorCard({required this.contributor, super.key});

  final Contributor contributor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final avatarUrl = contributor.avatarUrl;
    final profileUrl = contributor.htmlUrl;

    return AppPressable(
      onTap: () => unawaited(_openProfile(profileUrl)),
      semanticsLabel: contributor.login,
      semanticsButton: true,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                width: 64,
                height: 64,
                color: colors.surface2,
                child: avatarUrl.isEmpty
                    ? null
                    : Image.network(
                        avatarUrl,
                        excludeFromSemantics: true,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              contributor.login,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 2),
            Text(
              context.l10n.contributorCommitsCount(contributor.contributions),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.captionSmall.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProfile(String profileUrl) async {
    try {
      await launchUrl(Uri.parse(profileUrl), mode: .externalApplication);
    } on Exception catch (error, stackTrace) {
      log(
        'Could not open contributor profile',
        error: error,
        stackTrace: stackTrace,
        name: 'ContributorCard',
      );
    }
  }
}
