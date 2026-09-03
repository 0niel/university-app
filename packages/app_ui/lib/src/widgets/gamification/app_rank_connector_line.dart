import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/widgets.dart';

class AppRankConnectorLine extends StatelessWidget {
  const AppRankConnectorLine({required this.filled, super.key});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 3,
      margin: const EdgeInsets.only(
        bottom: AppSpacing.fieldGap,
        left: AppSpacing.xsm,
        right: AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: filled ? colors.accent : colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.connector),
      ),
    );
  }
}
