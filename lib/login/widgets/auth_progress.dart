import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AuthProgress extends StatelessWidget {
  const AuthProgress({required this.step, required this.total, super.key});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = NinjaMotion.of(context, NinjaMotion.fast);
    return Semantics(
      label: context.l10n.onboardingStepSemantics(step, total),
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index != 0) const SizedBox(width: 6),
            Expanded(
              child: AnimatedContainer(
                duration: duration,
                curve: NinjaMotion.enter,
                height: 3,
                decoration: BoxDecoration(
                  color: index < step ? colors.accent : colors.surface2,
                  borderRadius: BorderRadius.circular(AppRadius.xxs),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
