import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class BecomeContributorButton extends StatelessWidget {
  const BecomeContributorButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: l10n.toolsBecomeContributor,
      child: AppPressable(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.tint,
            borderRadius: .circular(AppRadius.full),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppControlSize.touchTarget,
            ),
            child: Padding(
              padding: const .symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: .min,
                spacing: 6,
                children: [
                  AppLineIconWidget(
                    .plus,
                    size: AppIconSize.sm,
                    color: colors.accent,
                  ),
                  Text(
                    l10n.toolsBecomeContributor,
                    style: AppText.caption.copyWith(
                      color: colors.accent,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
