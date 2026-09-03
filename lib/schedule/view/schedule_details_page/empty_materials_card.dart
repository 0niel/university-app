part of '../schedule_details_page.dart';

class _EmptyMaterialsCard extends StatelessWidget {
  const _EmptyMaterialsCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    semanticsLabel: context.l10n.lessonDetailsEmptyMaterialsTitle,
    child: Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const .all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        children: [
          Container(
            width: AppControlSize.touchTarget,
            height: AppControlSize.touchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: context.colors.tint,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              AppLineIcon.upload,
              color: context.colors.accent,
              size: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.gap),
          Text(
            context.l10n.lessonDetailsEmptyMaterialsTitle,
            textAlign: .center,
            style: AppText.body.copyWith(color: context.colors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.lessonDetailsEmptyMaterialsSub,
            textAlign: .center,
            style: AppText.subtext.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    ),
  );
}
