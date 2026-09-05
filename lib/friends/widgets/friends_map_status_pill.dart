import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsMapStatusPill extends StatelessWidget {
  const FriendsMapStatusPill({
    required this.isGhost,
    required this.friendsOnMap,
    required this.loading,
    super.key,
    this.showingStudents = false,
  });

  final bool isGhost;
  final int friendsOnMap;
  final bool loading;
  final bool showingStudents;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final accented = !loading && !isGhost;
    final label = showingStudents
        ? l10n.friendsMapPeopleCount(friendsOnMap)
        : isGhost
        ? l10n.friendsGhostMode
        : l10n.friendsOnMapLive(friendsOnMap);

    return Semantics(
      container: true,
      liveRegion: true,
      label: loading ? l10n.loadingContent : label,
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppControlSize.iconButton,
          ),
          padding: const .symmetric(
            horizontal: AppSpacing.sectionGap,
            vertical: AppSpacing.gap,
          ),
          decoration: BoxDecoration(
            color: accented ? colors.tint2 : colors.surface2,
            borderRadius: .circular(AppRadius.full),
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
                        color: accented ? colors.ink : colors.muted,
                        shape: .circle,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppText.captionSmall
                            .copyWith(
                              color: accented ? colors.ink : colors.muted,
                            )
                            .copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
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
