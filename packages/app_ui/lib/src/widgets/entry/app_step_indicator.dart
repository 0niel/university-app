import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    required this.step,
    required this.total,
    required this.semanticsLabel,
    super.key,
  })  : assert(total > 0, 'total must be positive'),
        assert(step > 0 && step <= total, 'step must be within total');

  final int step;
  final int total;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduced = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < total; index++) ...[
              if (index > 0) const SizedBox(width: 5),
              AnimatedContainer(
                duration:
                    reduced ? Duration.zero : const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 5,
                width: index == step - 1 ? 22 : 5,
                decoration: BoxDecoration(
                  color: index < step ? colors.ink : colors.surface2,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
