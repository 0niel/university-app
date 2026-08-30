part of '../view/onboarding_page.dart';

class _OnboardHeader extends StatelessWidget {
  const _OnboardHeader({
    required this.step,
    required this.total,
    this.onBack,
  });

  final int step;
  final int total;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final onBack = this.onBack;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            _OnboardCircleButton(
              icon: .chevronL,
              label: context.l10n.back,
              onTap: onBack,
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: _StepPills(step: step, total: total),
          ),
        ],
      ),
    );
  }
}
