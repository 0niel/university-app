import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class NinjaGapRow extends StatelessWidget {
  const NinjaGapRow({
    required this.text,
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.screen,
      vertical: AppSpacing.sm,
    ),
  });

  final String text;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rule = Expanded(
      child: SizedBox(height: 1, child: ColoredBox(color: colors.line)),
    );

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            rule,
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gap),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppText.captionStrong.copyWith(color: colors.muted2),
                ),
              ),
            ),
            rule,
          ],
        ),
      ),
    );
  }
}

class NinjaNowLine extends StatelessWidget {
  const NinjaNowLine({
    required this.label,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    this.onCanvas = false,
  });

  final String label;
  final EdgeInsets padding;
  final bool onCanvas;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: onCanvas ? colors.canvas : const Color(0x00000000),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: onCanvas ? AppSpacing.xs : AppSpacing.zero,
              ),
              child: Text(
                label,
                style: AppText.sans(10.5, FontWeight.w800, tabular: true)
                    .copyWith(color: colors.danger),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SizedBox(
              height: 8,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 2,
                    child: ColoredBox(color: colors.danger),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.danger,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef AppNowLine = NinjaNowLine;

typedef AppGapRow = NinjaGapRow;
