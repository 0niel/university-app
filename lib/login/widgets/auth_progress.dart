import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AuthProgress extends StatelessWidget {
  const AuthProgress({required this.step, required this.total, super.key});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) => AppStepIndicator(
    step: step,
    total: total,
    semanticsLabel: context.l10n.onboardingStepSemantics(step, total),
  );
}
