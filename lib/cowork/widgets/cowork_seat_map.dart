import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';
import 'package:rtu_mirea_app/cowork/utils/cowork_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkSeatMap extends StatelessWidget {
  const CoworkSeatMap({
    required this.seats,
    required this.selectedSeatId,
    required this.onSeatTap,
    super.key,
  });

  static const columns = 6;
  static const gap = 6.0;

  final List<CoworkSeat> seats;
  final String? selectedSeatId;
  final ValueChanged<String> onSeatTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final rows = (seats.length + columns - 1) ~/ columns;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(AppRadius.checkbox),
            ),
            child: Text(
              l10n.coworkWindows,
              style: AppText.typeTag.copyWith(color: colors.muted),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(
                  constraints.maxWidth,
                  columns * 44 + (columns - 1) * gap,
                ),
                child: Column(
                  children: [
                    for (var row = 0; row < rows; row++) ...[
                      if (row > 0) const SizedBox(height: gap),
                      Row(
                        children: [
                          for (var column = 0; column < columns; column++) ...[
                            if (column > 0) const SizedBox(width: gap),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: _cell(row * columns + column),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const CoworkSeatLegend(),
        ],
      ),
    );
  }

  Widget _cell(int index) {
    if (index >= seats.length) return const SizedBox.shrink();
    final seat = seats[index];
    return CoworkSeatCell(
      seat: seat,
      selected: seat.id == selectedSeatId,
      onTap: seat.isFree ? () => onSeatTap(seat.id) : null,
    );
  }
}

class CoworkSeatCell extends StatelessWidget {
  const CoworkSeatCell({
    required this.seat,
    required this.selected,
    super.key,
    this.onTap,
  });

  final CoworkSeat seat;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = coworkSeatPalette(
      context.colors,
      seat.status,
      selected: selected,
    );
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.coworkSeatSemantics(seat.id),
      semanticsButton: true,
      semanticsSelected: selected || seat.status == CoworkSeatStatus.mine,
      child: AnimatedContainer(
        duration: NinjaMotion.of(context, NinjaMotion.fast),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          '${seat.number}',
          style: AppText.sans(12, FontWeight.w800).copyWith(color: foreground),
        ),
      ),
    );
  }
}

class CoworkSeatLegend extends StatelessWidget {
  const CoworkSeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _LegendItem(color: colors.surface2, label: l10n.coworkLegendFree),
        _LegendItem(color: colors.accent, label: l10n.coworkLegendMine),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.bar),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}
