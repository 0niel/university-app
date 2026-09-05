import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWeeksHeader extends StatefulWidget {
  const CalendarWeeksHeader({
    required this.day,
    required this.pageController,
    required this.week,
    required this.format,
    this.onHeaderTap,
    this.onHeaderLongPress,
    super.key,
  });

  final DateTime day;
  final int week;
  final CalendarFormat format;
  final PageController? pageController;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onHeaderLongPress;

  @override
  State<CalendarWeeksHeader> createState() => _CalendarWeeksHeaderState();
}

class _CalendarWeeksHeaderState extends State<CalendarWeeksHeader> {
  int? _target;
  int _revision = 0;

  @override
  void didUpdateWidget(covariant CalendarWeeksHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      _revision++;
      _target = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMonthView = widget.format == .month;
    return Container(
      decoration: BoxDecoration(
        color: isMonthView ? null : colors.surface,
        borderRadius: isMonthView ? null : .circular(AppRadius.card),
      ),
      margin: const .symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          _buildNavigationButton(
            icon: AppLineIcon.chevronL,
            colors: colors,
            label: context.l10n.previousWeek,
            onPressed: () => _move(context, -1),
          ),
          Expanded(
            child: _buildHeaderTitle(context, colors, isMonthView),
          ),
          _buildNavigationButton(
            icon: AppLineIcon.chevronR,
            colors: colors,
            label: context.l10n.nextWeek,
            onPressed: () => _move(context, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required AppLineIcon icon,
    required AppColors colors,
    required String label,
    required VoidCallback onPressed,
  }) => AppPressable(
    onTap: onPressed,
    semanticsLabel: label,
    child: SizedBox.square(
      dimension: AppControlSize.touchTarget,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface2,
          shape: .circle,
        ),
        child: Center(
          child: AppLineIconWidget(icon, size: 18, color: colors.ink),
        ),
      ),
    ),
  );

  Widget _buildHeaderTitle(
    BuildContext context,
    AppColors colors,
    bool isMonthView,
  ) {
    final locale = Localizations.localeOf(context).toString();
    final formattedMonth = DateFormat.MMM(locale).format(widget.day);
    final monthAndYear =
        '${formattedMonth[0].toUpperCase()}${formattedMonth.substring(1)} '
        '${widget.day.year}';
    return AppPressable(
      onTap: widget.onHeaderTap,
      onLongPress: widget.onHeaderLongPress,
      semanticsLabel: monthAndYear,
      semanticsButton: widget.onHeaderTap != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xsm,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xsm,
            runSpacing: AppSpacing.xxs,
            children: [
              if (!isMonthView)
                Text(
                  monthAndYear,
                  style: AppText.body.copyWith(color: colors.muted),
                ),
              AppLineIconWidget(
                AppLineIcon.calendar,
                size: 14,
                color: colors.muted,
              ),
              Text(
                context.l10n.studyWeekNumber(widget.week),
                style: AppText.body.copyWith(
                  fontWeight: .w600,
                  color: colors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _reduceMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  void _move(BuildContext context, int delta) {
    final controller = widget.pageController;
    if (controller == null ||
        !controller.hasClients ||
        controller.positions.length != 1) {
      return;
    }
    final position = controller.position;
    if (!position.hasContentDimensions || position.viewportDimension == 0) {
      return;
    }
    final extent = position.viewportDimension * controller.viewportFraction;
    final maximum = (position.maxScrollExtent / extent).round();
    final target =
        ((_target ?? controller.page?.round() ?? controller.initialPage) +
                delta)
            .clamp(0, maximum);
    final revision = ++_revision;
    _target = target;
    if (_reduceMotion(context)) {
      controller.jumpToPage(target);
      _target = null;
      return;
    }
    unawaited(
      controller
          .animateToPage(
            target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() {
            if (mounted && revision == _revision) _target = null;
          }),
    );
  }
}
