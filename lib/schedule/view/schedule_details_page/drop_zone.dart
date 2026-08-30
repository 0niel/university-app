part of '../schedule_details_page.dart';

class _DropZone extends StatelessWidget {
  const _DropZone({required this.picked, required this.onTap});
  final _PickedMaterial? picked;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final picked = this.picked;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.lessonDetailsPickFileOrPhoto,
      child: Container(
        width: .infinity,
        padding: const .symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.brandTint,
                shape: .circle,
              ),
              child: AppLineIconWidget(
                .clipboard,
                size: 20,
                color: colors.brandInk,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              picked?.name ?? context.l10n.lessonDetailsPickFileOrPhoto,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.body.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 4),
            Text(
              picked == null
                  ? context.l10n.lessonDetailsDropHint
                  : _formatFileSize(context.l10n, picked.bytes.length),
              style: NinjaText.subtext.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
