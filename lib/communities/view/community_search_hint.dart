import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunitySearchHint extends StatelessWidget {
  const CommunitySearchHint({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.communitiesSearchHintInline,
      semanticsButton: true,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Row(
          spacing: 10,
          children: [
            AppLineIconWidget(.search, size: 17, color: colors.muted),
            Text(
              context.l10n.communitiesSearchHintInline,
              style: NinjaText.body.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
