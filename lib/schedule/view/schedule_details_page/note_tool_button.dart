part of '../schedule_details_page.dart';

class _NoteToolButton extends StatelessWidget {
  const _NoteToolButton({required this.icon, required this.onTap});
  final AppLineIcon icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: NinjaMetrics.minTouchTarget,
        height: NinjaMetrics.minTouchTarget,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.control),
        ),
        child: Center(
          child: AppLineIconWidget(icon, size: 18, color: colors.mutedDark),
        ),
      ),
    );
  }
}
