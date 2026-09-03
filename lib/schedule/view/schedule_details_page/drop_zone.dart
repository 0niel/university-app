part of '../schedule_details_page.dart';

class _DropZone extends StatelessWidget {
  const _DropZone({required this.picked, required this.onTap});
  final _PickedMaterial? picked;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final picked = this.picked;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.lessonDetailsPickFileOrPhoto,
      child: Container(
        width: .infinity,
        padding: const .symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xlg,
        ),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Column(
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
                size: 20,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: AppSpacing.gap),
            Text(
              picked?.name ?? context.l10n.lessonDetailsPickFileOrPhoto,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppText.body.copyWith(color: colors.ink),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              picked == null
                  ? context.l10n.lessonDetailsDropHint
                  : _formatFileSize(context.l10n, picked.bytes.length),
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
