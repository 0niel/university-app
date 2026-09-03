import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/app_segmented_control.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
    this.semanticsLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 200);
    final label = this.label;

    return AppPressState(
      onTap: enabled ? () => onChanged(!value) : null,
      enabled: enabled,
      semanticsLabel: semanticsLabel ?? label,
      semanticsButton: true,
      semanticsToggled: value,
      builder: (context, {required pressed}) => Opacity(
        opacity: enabled ? 1 : .45,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppControlSize.switchWidth,
              height: AppControlSize.touchTarget,
              child: Center(
                child: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeOut,
                  width: AppControlSize.switchWidth,
                  height: AppControlSize.switchHeight,
                  decoration: BoxDecoration(
                    color: value ? colors.accent : colors.surface2,
                    borderRadius: BorderRadius.circular(
                      AppControlSize.switchHeight / 2,
                    ),
                  ),
                  child: AnimatedAlign(
                    duration: duration,
                    curve: Curves.easeOut,
                    alignment:
                        value ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.micro,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Text(
                  label,
                  style: AppText.captionStrong.copyWith(color: colors.muted),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppToggle extends StatelessWidget {
  const AppToggle({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) =>
      AppSwitch(value: value, onChanged: onChanged, label: label);
}

class AppLangToggle extends StatelessWidget {
  const AppLangToggle({
    required this.value,
    required this.options,
    super.key,
    this.onChanged,
    this.onCanvas = false,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final bool onCanvas;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: AppSegmentedControl<String>(
        value: value,
        onChanged: onChanged,
        onCanvas: onCanvas,
        options: [
          for (final option in options)
            AppSegmentedOption(value: option, label: option),
        ],
      ),
    );
  }
}
