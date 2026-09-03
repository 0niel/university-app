part of '../schedule_details_page.dart';

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final AppLineIcon icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        padding: const .symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Column(
          spacing: AppSpacing.xsm,
          children: [
            AppLineIconWidget(icon, size: 20, color: colors.muted),
            Text(
              label,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppText.captionSmall.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
