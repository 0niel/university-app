import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/widgets.dart';

class AppShortcutGrid extends StatelessWidget {
  const AppShortcutGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final columns = scale > 1.5 || constraints.maxWidth < 300 ? 3 : 5;
      final width =
          (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.md,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
