part of '../schedule_details_page.dart';

class _ContributeBanner extends StatelessWidget {
  const _ContributeBanner({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.lessonDetailsUpload,
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Row(
          spacing: 12,
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.brandTint,
                shape: .circle,
              ),
              child: AppLineIconWidget(
                .clipboard,
                size: 19,
                color: colors.brandInk,
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: context.l10n.lessonDetailsContributePre),
                    TextSpan(
                      text: context.l10n.lessonDetailsShurikensReward,
                      style: TextStyle(color: colors.brandInk),
                    ),
                    TextSpan(text: context.l10n.lessonDetailsContributePost),
                  ],
                ),
                style: NinjaText.subtext.copyWith(
                  color: colors.mutedDark,
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
