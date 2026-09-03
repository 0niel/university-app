import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_segmented_bar.dart';
import 'package:flutter/widgets.dart';

class AppDensityBar extends StatelessWidget {
  const AppDensityBar({
    required this.segments,
    super.key,
    this.leftLabel,
    this.centerLabel,
    this.rightLabel,
  });

  final List<Color> segments;
  final String? leftLabel;
  final String? centerLabel;
  final String? rightLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final center = centerLabel;
    final hasLabels = leftLabel != null || center != null || rightLabel != null;
    final style = AppText.captionSmall.copyWith(color: colors.muted2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSegmentedBar(
          segments: [
            for (final color in segments)
              AppSegmentedBarPart(flex: 1, color: color),
          ],
        ),
        if (hasLabels) ...[
          const SizedBox(height: AppSpacing.xsm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel ?? '', style: style),
              if (center != null) Text(center, style: style),
              Text(rightLabel ?? '', style: style),
            ],
          ),
        ],
      ],
    );
  }
}
