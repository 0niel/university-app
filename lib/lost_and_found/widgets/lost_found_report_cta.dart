import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundReportCta extends StatelessWidget {
  const LostFoundReportCta({
    required this.onTap,
    this.accented = true,
    super.key,
  });

  final VoidCallback? onTap;
  final bool accented;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final enabled = onTap != null;
    final pastel = accented && enabled;
    final title = pastel ? colors.ink : colors.ink;
    final support = pastel ? colors.muted : colors.muted;
    return AppPressable(
      onTap: onTap,
      enabled: enabled,
      semanticsLabel: l10n.lostFoundReportTitle,
      semanticsButton: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: pastel ? colors.tint : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: AppControlSize.iconButton,
              height: AppControlSize.iconButton,
              decoration: BoxDecoration(
                color: pastel
                    ? colors.ink.withValues(alpha: .12)
                    : colors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.field),
              ),
              alignment: Alignment.center,
              child: AppLineIconWidget(
                AppLineIcon.plus,
                size: 20,
                color: pastel ? colors.ink : colors.muted,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.lostFoundReportTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headline.copyWith(color: title),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.lostFoundReportSub,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.captionSmall.copyWith(color: support),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: pastel ? colors.muted : colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}
