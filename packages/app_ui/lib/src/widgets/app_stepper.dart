import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppStepper extends StatelessWidget {
  const AppStepper({
    required this.value,
    super.key,
    this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canDecrement = onChanged != null && value > min;
    final canIncrement = onChanged != null && value < max;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          semanticLabel: '−',
          onTap: canDecrement ? () => onChanged?.call(value - 1) : null,
          background: colors.surfaceHigh,
          child: Container(
            width: 12,
            height: 2,
            decoration: BoxDecoration(
              color: colors.deactive,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 28,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: AppText.tabular(
              AppText.heading.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.active,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _StepButton(
          semanticLabel: '+',
          onTap: canIncrement ? () => onChanged?.call(value + 1) : null,
          background: colors.primary,
          child: Icon(Icons.add_rounded, size: 15, color: colors.onAccent),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.background,
    required this.child,
    required this.semanticLabel,
    this.onTap,
  });

  final Color background;
  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      pressedScale: 0.92,
      onTap: onTap,
      semanticsLabel: semanticLabel,
      semanticsButton: true,
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: Material(
            color: background,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: SizedBox.square(
              dimension: 32,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
