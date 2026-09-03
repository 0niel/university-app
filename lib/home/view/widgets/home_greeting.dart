import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    required this.greeting,
    required this.name,
    required this.subtitle,
    super.key,
  });

  final String greeting;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = AppText.serif(32, height: 1.08, letterSpacingEm: -0.02);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.contentGap,
            bottom: AppSpacing.xsm,
          ),
          child: AppBalancedText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: greeting,
                  style: title.copyWith(color: colors.ink),
                ),
                TextSpan(
                  text: name,
                  style: AppText.serif(
                    32,
                    height: 1.08,
                    letterSpacingEm: -0.02,
                    italic: true,
                  ).copyWith(color: colors.accent),
                ),
              ],
            ),
          ),
        ),
        Text(
          subtitle,
          style: AppText.sans(14, FontWeight.w500, height: 1.4).copyWith(
            color: colors.muted,
          ),
        ),
      ],
    );
  }
}
