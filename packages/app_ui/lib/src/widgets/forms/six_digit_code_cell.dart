import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class SixDigitCodeCell extends StatelessWidget {
  const SixDigitCodeCell({
    required this.digit,
    required this.active,
    super.key,
    this.onTap,
    this.fillColor,
    this.height = AppControlSize.buttonHero,
  });

  final String? digit;
  final bool active;
  final VoidCallback? onTap;
  final Color? fillColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final digit = this.digit;
    final filled = digit != null && digit.isNotEmpty;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return AppPressState(
      onTap: onTap,
      semanticsButton: onTap != null,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: height,
        decoration: BoxDecoration(
          color: fillColor ?? (filled ? colors.tint : colors.surface2),
          borderRadius: BorderRadius.circular(AppRadius.banner),
          border: Border.all(
            color: active ? colors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          digit ?? '',
          style: AppText.code.copyWith(color: colors.ink),
        ),
      ),
    );
  }
}

class AppCodeKeypad extends StatelessWidget {
  const AppCodeKeypad({
    required this.onKey,
    required this.onBackspace,
    super.key,
    this.backspaceLabel = '⌫',
    this.spacing = AppSpacing.xsm,
    this.height = AppControlSize.iconButtonSmall,
    this.enabled = true,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onBackspace;
  final String backspaceLabel;
  final double spacing;
  final double height;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    return LayoutBuilder(
      builder: (context, constraints) {
        final keys = [...digits, backspaceLabel];
        final compact = constraints.maxWidth.isFinite &&
            constraints.maxWidth <
                AppControlSize.touchTarget * keys.length +
                    spacing * (keys.length - 1);
        final columns = compact
            ? ((constraints.maxWidth + spacing) /
                    (AppControlSize.touchTarget + spacing))
                .floor()
                .clamp(1, 3)
            : keys.length;
        final width = compact
            ? (constraints.maxWidth - spacing * (columns - 1)) / columns
            : null;
        final buttons = [
          for (final key in keys)
            _KeypadKey(
              label: key,
              height: height,
              enabled: enabled,
              onTap: key == backspaceLabel ? onBackspace : () => onKey(key),
            ),
        ];
        if (compact) {
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final button in buttons)
                SizedBox(width: width, child: button),
            ],
          );
        }
        return Row(
          children: [
            for (final (index, button) in buttons.indexed) ...[
              if (index > 0) SizedBox(width: spacing),
              if (constraints.maxWidth.isFinite)
                Expanded(child: button)
              else
                SizedBox(width: AppControlSize.touchTarget, child: button),
            ],
          ],
        );
      },
    );
  }
}

class _KeypadKey extends StatelessWidget {
  const _KeypadKey({
    required this.label,
    required this.height,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final double height;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return AppPressState(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      semanticsLabel: label,
      semanticsButton: true,
      builder: (context, {required pressed}) => ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Center(
          heightFactor: 1,
          child: AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            height: height,
            decoration: BoxDecoration(
              color: !enabled || pressed ? colors.canvas : colors.surface2,
              borderRadius: BorderRadius.circular(AppRadius.iconTile),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppText.sans(14, FontWeight.w700)
                  .copyWith(color: enabled ? colors.ink : colors.muted2),
            ),
          ),
        ),
      ),
    );
  }
}
