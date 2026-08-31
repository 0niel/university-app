import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsMapStatusPill extends StatelessWidget {
  const FriendsMapStatusPill({
    required this.isGhost,
    required this.friendsOnMap,
    required this.loading,
    super.key,
  });

  final bool isGhost;
  final int friendsOnMap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final accented = !loading && !isGhost;
    final label = isGhost
        ? l10n.friendsGhostMode
        : l10n.friendsOnMapLive(friendsOnMap);

    return Semantics(
      container: true,
      liveRegion: true,
      label: loading ? l10n.loadingContent : label,
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          padding: const .symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: accented ? colors.accentSoft : colors.surfaceAlt,
            borderRadius: .circular(NinjaRadius.pill),
          ),
          child: loading
              ? const Center(
                  child: NinjaSkeleton.bar(height: 10, widthFactor: 0.72),
                )
              : Row(
                  mainAxisAlignment: .center,
                  spacing: 7,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: accented ? colors.onAccentSoft : colors.muted,
                        shape: .circle,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.tabular(
                          NinjaText.microLabel.copyWith(
                            color: accented
                                ? colors.onAccentSoft
                                : colors.mutedDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
