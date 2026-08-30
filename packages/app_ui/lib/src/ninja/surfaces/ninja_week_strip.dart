import 'dart:math' as math;

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaWeekStrip extends StatelessWidget {
  const NinjaWeekStrip({
    required this.days,
    required this.selectedIndex,
    super.key,
    this.onSelected,
  });

  final List<NinjaWeekDay> days;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : days.length * 52 + 24;
        final available = math.max(0, maxWidth - 24).toDouble();
        final width = days.isEmpty
            ? 52.0
            : math.max(52, available / days.length).toDouble();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (var index = 0; index < days.length; index++)
                _NinjaWeekCell(
                  width: width,
                  day: days[index],
                  selected: index == selectedIndex,
                  onTap: onSelected == null ? null : () => onSelected!(index),
                ),
            ],
          ),
        );
      },
    );
  }
}

class NinjaWeekDay {
  const NinjaWeekDay(this.label, {this.isWeekend = false});

  final String label;
  final bool isWeekend;
}

class _NinjaWeekCell extends StatelessWidget {
  const _NinjaWeekCell({
    required this.width,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final double width;
  final NinjaWeekDay day;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return AppPressable(
      onTap: onTap,
      semanticsLabel: day.label,
      semanticsSelected: selected,
      child: SizedBox(
        width: width,
        height: 52,
        child: Center(
          child: AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? colors.brand : const Color(0x00000000),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              day.label,
              style: NinjaText.body.copyWith(
                color: selected
                    ? colors.onBrand
                    : day.isWeekend
                        ? colors.muted
                        : colors.mutedDark,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
