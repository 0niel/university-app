import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaFindFriendsInviteCard extends StatelessWidget {
  const NinjaFindFriendsInviteCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel:
            '${l10n.friendsInviteTelegram}, ${l10n.friendsInviteTelegramSub}',
        semanticsButton: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                Container(
                  width: NinjaMetrics.minTouchTarget,
                  height: NinjaMetrics.minTouchTarget,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    shape: .circle,
                  ),
                  child: AppLineIconWidget(
                    .share,
                    size: 20,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 3,
                    children: [
                      Text(
                        l10n.friendsInviteTelegram,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      Text(
                        l10n.friendsInviteTelegramSub,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
