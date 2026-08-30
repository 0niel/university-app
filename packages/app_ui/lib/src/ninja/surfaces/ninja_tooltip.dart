import 'dart:math' as math;

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaTooltip extends StatelessWidget {
  const NinjaTooltip({
    required this.message,
    super.key,
    this.arrow = NinjaTooltipArrow.up,
    this.arrowInset = 22,
  });

  final String message;
  final NinjaTooltipArrow arrow;
  final double arrowInset;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final arrowSquare = Transform.rotate(
      angle: math.pi / 4,
      child: Container(width: 10, height: 10, color: colors.ink),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PositionedDirectional(
          start: arrowInset,
          top: arrow == NinjaTooltipArrow.up ? -5 : null,
          bottom: arrow == NinjaTooltipArrow.down ? -5 : null,
          child: arrowSquare,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            child: Text(
              message,
              style: NinjaText.subtext.copyWith(
                fontSize: 12,
                color: colors.onInk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum NinjaTooltipArrow { up, down }

class NinjaFeatureHint extends StatelessWidget {
  const NinjaFeatureHint({
    required this.title,
    required this.body,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final action = actionLabel;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brand.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox.square(
                dimension: 36,
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.spark,
                    size: 17,
                    color: colors.brand,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: NinjaText.subtext.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                  if (action != null) ...[
                    const SizedBox(height: 4),
                    Semantics(
                      button: onAction != null,
                      child: AppPressable(
                        onTap: onAction,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              action,
                              style: NinjaText.helper.copyWith(
                                color: colors.brandInk,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
