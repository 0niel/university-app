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
    final colors = context.ninja;
    final l10n = context.l10n;
    final enabled = onTap != null;
    final pastel = accented && enabled;
    final title = pastel ? colors.onAccentSoft : colors.ink;
    final support = pastel ? colors.onAccentSoftMuted : colors.muted;
    return AppPressable(
      onTap: onTap,
      enabled: enabled,
      semanticsLabel: l10n.lostFoundReportTitle,
      semanticsButton: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: pastel ? colors.accentSoft : colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              decoration: BoxDecoration(
                color: pastel
                    ? colors.onAccentSoft.withValues(alpha: .12)
                    : colors.surfaceAlt,
                borderRadius: BorderRadius.circular(NinjaRadius.control),
              ),
              alignment: Alignment.center,
              child: AppLineIconWidget(
                AppLineIcon.plus,
                size: 20,
                color: pastel ? colors.onAccentSoft : colors.muted,
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
                    style: NinjaText.headline.copyWith(color: title),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.lostFoundReportSub,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.helper.copyWith(color: support),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: pastel ? colors.onAccentSoftMuted : colors.chevron,
            ),
          ],
        ),
      ),
    );
  }
}
