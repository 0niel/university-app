import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';

class NinjaSegmented<T> extends StatelessWidget {
  const NinjaSegmented({
    required this.segments,
    required this.value,
    super.key,
    this.onChanged,
    this.expanded = false,
  });
  final List<NinjaSegment<T>> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final enabled = onChanged != null;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final widgets = <Widget>[
      for (final segment in segments)
        _buildSegment(context, colors, segment, largeText: largeText),
    ];

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: largeText
          ? Wrap(spacing: 8, runSpacing: 8, children: widgets)
          : Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                for (var index = 0; index < widgets.length; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  if (expanded)
                    Expanded(child: widgets[index])
                  else
                    widgets[index],
                ],
              ],
            ),
    );
  }

  Widget _buildSegment(
    BuildContext context,
    NinjaColors colors,
    NinjaSegment<T> segment, {
    required bool largeText,
  }) {
    final selected = segment.value == value;
    final onChanged = this.onChanged;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);

    return AppPressable(
      haptics: !selected,
      onTap: onChanged == null
          ? null
          : () {
              if (!selected) onChanged(segment.value);
            },
      child: Semantics(
        button: true,
        selected: selected,
        enabled: onChanged != null,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(NinjaRadius.button),
          ),
          child: AnimatedDefaultTextStyle(
            duration: duration,
            curve: Curves.easeOut,
            style: NinjaText.body.copyWith(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              color: selected ? colors.onBrand : colors.mutedDark,
            ),
            child: Text(
              segment.label,
              maxLines: largeText ? 2 : 1,
              overflow: largeText ? TextOverflow.visible : TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class NinjaSegment<T> {
  const NinjaSegment({required this.value, required this.label});
  final T value;
  final String label;
}
