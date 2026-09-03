import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    required this.value,
    required this.groupValue,
    super.key,
    this.onChanged,
    this.label,
    this.semanticsLabel,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final selected = value == groupValue;
    final label = this.label;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return AppPressState(
      onTap: enabled ? () => onChanged(value) : null,
      enabled: enabled,
      semanticsLabel: semanticsLabel ?? label,
      semanticsButton: false,
      semanticsChecked: selected,
      semanticsExclusive: true,
      builder: (context, {required pressed}) => ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: label == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              width: AppControlSize.checkbox,
              height: AppControlSize.checkbox,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: !enabled
                      ? colors.surface2
                      : selected
                          ? colors.accent
                          : colors.muted2,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected && enabled
                        ? colors.accent
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Text(
                  label,
                  style: AppText.label.copyWith(
                    color: enabled ? colors.ink : colors.muted2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NinjaRadio<T> extends StatelessWidget {
  const NinjaRadio({
    required this.value,
    required this.groupValue,
    super.key,
    this.onChanged,
    this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) => AppRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        label: label,
      );
}
