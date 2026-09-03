part of '../schedule_details_page.dart';

class _ContributeBanner extends StatelessWidget {
  const _ContributeBanner({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.lessonDetailsUpload,
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Container(
              width: AppControlSize.touchTarget,
              height: AppControlSize.touchTarget,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.tint,
                shape: .circle,
              ),
              child: AppLineIconWidget(
                .clipboard,
                size: 19,
                color: colors.accent,
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: context.l10n.lessonDetailsContributePre),
                    TextSpan(
                      text: context.l10n.lessonDetailsShurikensReward,
                      style: TextStyle(color: colors.accent),
                    ),
                    TextSpan(text: context.l10n.lessonDetailsContributePost),
                  ],
                ),
                style: AppText.subtext.copyWith(
                  color: colors.muted,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
