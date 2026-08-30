import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ScheduleViewSelectorSkeleton extends StatelessWidget {
  const ScheduleViewSelectorSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final labels = [
      context.l10n.viewDay,
      context.l10n.viewWeek,
      context.l10n.viewMonth,
    ];
    final scale = math
        .max(1, MediaQuery.textScalerOf(context).scale(1))
        .toDouble();
    final height = NinjaMetrics.minTouchTarget + (scale - 1) * 12;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        2,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Container(
        padding: const .all(4),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Row(
          children: [
            for (final (index, label) in labels.indexed)
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: height),
                  alignment: .center,
                  padding: const .symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: index == 0 ? colors.brand : Colors.transparent,
                    borderRadius: .circular(NinjaRadius.pill),
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: .ellipsis,
                    textAlign: .center,
                    style: NinjaText.buttonSmall.copyWith(
                      color: index == 0 ? colors.onBrand : colors.mutedDark,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
