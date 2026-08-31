part of '../view/onboarding_page.dart';

class _StepPills extends StatelessWidget {
  const _StepPills({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reached = step.clamp(0, total);
    final duration = NinjaMotion.of(context, NinjaMotion.fast);
    return Semantics(
      value: '$step / $total',
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index != 0) const SizedBox(width: 6),
            Expanded(
              child: AnimatedContainer(
                duration: duration,
                curve: NinjaMotion.enter,
                height: 6,
                decoration: BoxDecoration(
                  color: index < reached ? colors.brand : colors.surfaceAlt,
                  borderRadius: .circular(NinjaRadius.pill),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
