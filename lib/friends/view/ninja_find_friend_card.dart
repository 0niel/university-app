import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/friends_layout.dart';

class NinjaFindFriendCard extends StatelessWidget {
  const NinjaFindFriendCard({
    required this.name,
    required this.subtitle,
    required this.trailing,
    this.selected = false,
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      child: Padding(
        padding: const .fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          10,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? colors.surface2 : colors.surface,
            borderRadius: .circular(AppRadius.card),
          ),
          child: Padding(
            padding: const .all(AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked =
                    constraints.maxWidth < FriendsLayout.compactCardWidth ||
                    MediaQuery.textScalerOf(context).scale(1) >=
                        FriendsLayout.largeTextScale;
                final identity = Row(
                  children: [
                    AppAvatar(name: name, size: FriendsLayout.avatar),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        spacing: 3,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: .ellipsis,
                            style: AppText.cell.copyWith(color: colors.ink),
                          ),
                          if (subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: .ellipsis,
                              style: AppText.caption.copyWith(
                                color: colors.muted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!stacked) ...[
                      const SizedBox(width: AppSpacing.gap),
                      trailing,
                    ],
                  ],
                );
                return stacked
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          identity,
                          const SizedBox(height: AppSpacing.md),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: trailing,
                          ),
                        ],
                      )
                    : identity;
              },
            ),
          ),
        ),
      ),
    );
  }
}
