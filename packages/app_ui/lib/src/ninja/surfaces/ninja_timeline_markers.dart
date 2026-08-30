import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class NinjaGapRow extends StatelessWidget {
  const NinjaGapRow({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Center(
                child: AppLineIconWidget(
                  AppLineIcon.clock,
                  size: 17,
                  color: colors.mutedDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: NinjaText.subtext.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class NinjaNowLine extends StatelessWidget {
  const NinjaNowLine({
    required this.label,
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: NinjaMetrics.screenPadding,
    ),
  });

  final String label;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: padding,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.brandTint,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLineIconWidget(
                  AppLineIcon.clock,
                  size: 14,
                  color: colors.brand,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: NinjaText.badge.copyWith(
                    color: colors.brandInk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
