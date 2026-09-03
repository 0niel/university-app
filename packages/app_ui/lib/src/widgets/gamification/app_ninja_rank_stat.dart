import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class AppNinjaRankStat extends StatelessWidget {
  const AppNinjaRankStat({
    required this.value,
    required this.label,
    required this.color,
    super.key,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppText.metric.copyWith(color: color)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: AppText.captionSmall.copyWith(
            color: color.withValues(alpha: .8),
          ),
        ),
      ],
    );
  }
}
