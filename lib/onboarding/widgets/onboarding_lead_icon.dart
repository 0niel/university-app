part of '../view/onboarding_page.dart';

class _OnboardingLeadIcon extends StatelessWidget {
  const _OnboardingLeadIcon(this.icon);

  final AppLineIcon icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandTint,
          shape: .circle,
        ),
        child: SizedBox.square(
          dimension: NinjaMetrics.minTouchTarget,
          child: AppLineIconWidget(icon, size: 20, color: colors.brand),
        ),
      ),
    );
  }
}
