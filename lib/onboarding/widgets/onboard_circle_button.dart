part of '../view/onboarding_page.dart';

class _OnboardCircleButton extends StatelessWidget {
  const _OnboardCircleButton({
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
      semanticsButton: true,
      child: Container(
        width: NinjaMetrics.minTouchTarget,
        height: NinjaMetrics.minTouchTarget,
        alignment: .center,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          shape: .circle,
        ),
        child: AppLineIconWidget(icon, size: 20, color: colors.ink),
      ),
    );
  }
}
