import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunitySuggestionCard extends StatelessWidget {
  const NinjaCommunitySuggestionCard({required this.uri, super.key});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: AppPressable(
        onTap: () => unawaited(launchCommunityUrl(context, uri)),
        semanticsLabel: context.l10n.communitiesSuggestTitle,
        semanticsButton: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        context.l10n.communitiesSuggestTitle,
                        style: NinjaText.headline.copyWith(
                          color: colors.onAccentSoft,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.l10n.communitiesSuggestSubtitle,
                        style: NinjaText.helper.copyWith(
                          color: colors.onAccentSoftMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppLineIconWidget(
                  .external,
                  size: 18,
                  color: colors.onAccentSoftMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
