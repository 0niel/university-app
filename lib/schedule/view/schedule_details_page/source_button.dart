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
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          spacing: 6,
          children: [
            AppLineIconWidget(icon, size: 20, color: colors.mutedDark),
            Text(
              label,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.helper.copyWith(color: colors.mutedDark),
            ),
          ],
        ),
      ),
    );
  }
}
