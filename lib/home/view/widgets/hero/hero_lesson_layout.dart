import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';

class HeroLessonLayout extends StatelessWidget {
  const HeroLessonLayout({
    required this.start,
    required this.end,
    required this.child,
    super.key,
  });

  final String start;
  final String end;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          constraints.maxWidth < 260 ||
          MediaQuery.textScalerOf(context).scale(1) > 1.3;
      final time = HeroTimeColumn(start: start, end: end, horizontal: stacked);
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            time,
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          time,
          const SizedBox(width: AppSpacing.md),
          Expanded(child: child),
        ],
      );
    },
  );
}
