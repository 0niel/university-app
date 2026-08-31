import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
    final colors = Theme.of(context).colors;
    final center = centerLabel;
    final hasLabels = leftLabel != null || center != null || rightLabel != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                for (var i = 0; i < segments.length; i++) ...[
                  Expanded(child: ColoredBox(color: segments[i])),
                  if (i != segments.length - 1) const SizedBox(width: 3),
                ],
              ],
            ),
          ),
        ),
        if (hasLabels) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel ?? '', style: _labelStyle(colors)),
              if (center != null) Text(center, style: _labelStyle(colors)),
              Text(rightLabel ?? '', style: _labelStyle(colors)),
            ],
          ),
        ],
      ],
    );
  }

  TextStyle _labelStyle(AppColors colors) => AppText.captionSmall.copyWith(
        fontSize: 10,
        color: colors.deactiveDarker,
        fontWeight: FontWeight.w600,
      );
}
