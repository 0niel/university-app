import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_button.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    required this.day,
    required this.name,
    this.nameSemanticsLabel,
    this.topInset = 0,
    super.key,
  });
  final DateTime day;
  final String? name;
  final String? nameSemanticsLabel;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final week = studyWeekNumber(day);
    final parity = week.isEven
        ? l10n.weekParityEvenFull
        : l10n.weekParityOddFull;
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.scheduleWeekOverline(
            week,
            parity,
          ),
          style: AppText.sans(
            12,
            FontWeight.w600,
          ).copyWith(color: colors.accent),
        ),
        const SizedBox(height: AppSpacing.xsm),
        Text(
          l10n.scheduleLessonsTitle,
          style: AppText.sans(
            35,
            FontWeight.w800,
            height: 1.1,
            letterSpacingEm: -.045,
          ).copyWith(color: colors.ink),
        ),
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SchedulePickerButton(
            name: name,
            semanticsLabel: nameSemanticsLabel,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.tune),
          shape: AppIconButtonShape.circle,
          tone: AppIconButtonTone.surface,
          tooltip: l10n.scheduleFilterSemantics,
          onPressed: () => showScheduleFilterSheet(context, day: day),
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        math.max(
          AppSpacing.screenTop - topInset,
          MediaQuery.paddingOf(context).top + AppSpacing.md,
        ),
        AppSpacing.screen,
        AppSpacing.lg,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked =
              constraints.maxWidth < 320 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.3;
          return stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    title,
                    const SizedBox(height: AppSpacing.md),
                    actions,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: AppSpacing.gap),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * .56,
                      ),
                      child: actions,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
