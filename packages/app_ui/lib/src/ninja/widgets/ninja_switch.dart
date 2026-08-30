import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';

const _kOffTrackLight = Color(0xFFE3E3E8);

class NinjaSwitch extends StatelessWidget {
  const NinjaSwitch({required this.value, super.key, this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);

    var track = colors.isDark ? colors.line : _kOffTrackLight;
    var knob = colors.isDark ? colors.mutedDark : colors.canvas;
    if (value) {
      track = colors.brand;
      knob = colors.onBrand;
    }
    if (!enabled) track = colors.surface;

    return Semantics(
      toggled: value,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? () => onChanged(!value) : null,
        child: SizedBox(
          width: 48,
          height: 44,
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: AnimatedContainer(
                duration: duration,
                curve: Curves.easeOut,
                width: 46,
                height: 28,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: track,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedAlign(
                  duration: duration,
                  curve: Curves.easeOut,
                  alignment:
                      value ? Alignment.centerRight : Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: knob,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 22),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
