import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

const _stepperButtonSize = 40.0;
const _stepperValueWidth = 28.0;

class AppStepper extends StatelessWidget {
  const AppStepper({
    required this.value,
    super.key,
    this.onChanged,
    this.min = 0,
    this.max = 99,
    this.decrementSemanticLabel = '−',
    this.incrementSemanticLabel = '+',
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final String decrementSemanticLabel;
  final String incrementSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canDecrement = onChanged != null && value > min;
    final canIncrement = onChanged != null && value < max;

    return Container(
      height: AppControlSize.field,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: AppLineIcon.minus,
            semanticLabel: decrementSemanticLabel,
            color: canDecrement ? colors.ink : colors.muted2,
            onTap: canDecrement ? () => onChanged?.call(value - 1) : null,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _stepperValueWidth),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppText.sans(15, FontWeight.w700, tabular: true).copyWith(
                color: colors.ink,
              ),
            ),
          ),
          _StepButton(
            icon: AppLineIcon.plus,
            semanticLabel: incrementSemanticLabel,
            color: canIncrement ? colors.ink : colors.muted2,
            onTap: canIncrement ? () => onChanged?.call(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.semanticLabel,
    required this.color,
    this.onTap,
  });

  final AppLineIcon icon;
  final String semanticLabel;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return AppPressState(
      onTap: onTap,
      enabled: onTap != null,
      semanticsLabel: semanticLabel,
      semanticsButton: true,
      builder: (context, {required pressed}) => SizedBox.square(
        dimension: AppControlSize.touchTarget,
        child: Center(
          child: AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: _stepperButtonSize,
            height: _stepperButtonSize,
            decoration: BoxDecoration(
              color: pressed ? colors.canvas : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppLineIconWidget(
                icon,
                size: AppIconSize.sm,
                color: color,
                strokeWidth: 2.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
