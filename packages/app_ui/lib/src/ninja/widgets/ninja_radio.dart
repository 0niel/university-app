import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';

class NinjaRadio<T> extends StatelessWidget {
  const NinjaRadio({
    required this.value,
    required this.groupValue,
    super.key,
    this.onChanged,
  });
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final selected = value == groupValue;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? () => onChanged(value) : null,
        child: SizedBox.square(
          dimension: NinjaMetrics.minTouchTarget,
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? colors.brand : colors.disabledLine,
                    width: selected ? 7 : NinjaMetrics.lineWidth,
                  ),
                ),
                child: const SizedBox.square(dimension: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
