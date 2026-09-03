import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rtu_mirea_app/friends/friends_layout.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';

class FindFriendsMyQrSheet extends StatelessWidget {
  const FindFriendsMyQrSheet({
    required this.userId,
    required this.onShare,
    super.key,
  });

  final String userId;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      children: [
        Center(
          child: Container(
            padding: const .all(AppSpacing.screen),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: .circular(AppRadius.card),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => QrImageView(
                data: DeepLinks.appLink(
                  '/services/people?add=$userId',
                ).toString(),
                size: constraints.maxWidth
                    .clamp(0, FriendsLayout.qrCode)
                    .toDouble(),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        Text(
          l10n.friendsMyQrHint,
          textAlign: .center,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.screen),
        FriendsPillButton(
          label: l10n.friendsShareLink,
          icon: .share,
          tone: .neutral,
          expanded: true,
          onTap: () {
            unawaited(Navigator.of(context).maybePop());
            onShare();
          },
        ),
      ],
    );
  }
}
