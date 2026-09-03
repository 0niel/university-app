import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/calendar_weeks_header.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.day,
    required this.week,
    required this.format,
    required this.pageController,
    required this.onMonthChanged,
    this.onHeaderTap,
    this.onHeaderLongPress,
    this.animationController,
    super.key,
  });

  final DateTime day;
  final int week;
  final CalendarFormat format;
  final PageController? pageController;
  final ValueSetter<int> onMonthChanged;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onHeaderLongPress;
  final AnimationController? animationController;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  late final ScrollController _monthScrollController;

  @override
  void initState() {
    super.initState();
    _monthScrollController = ScrollController(
      initialScrollOffset: _monthScrollOffset(widget.day.month),
    );
  }

  @override
  void didUpdateWidget(covariant CalendarHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day.month == widget.day.month ||
        !_monthScrollController.hasClients) {
      return;
    }

    final position = _monthScrollController.position;
    final offset = _monthScrollOffset(
      widget.day.month,
    ).clamp(position.minScrollExtent, position.maxScrollExtent);
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduceMotion) {
      _monthScrollController.jumpTo(offset);
      return;
    }
    unawaited(
      _monthScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _monthScrollController.dispose();
    super.dispose();
  }

  double _monthScrollOffset(int month) {
    const visibleLeadingMonths = 2;
    const itemWidth = 68.0;
    return month > visibleLeadingMonths + 1
        ? (month - visibleLeadingMonths - 1) * itemWidth
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final animation = reduceMotion ? null : widget.animationController;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          CalendarWeeksHeader(
            day: widget.day,
            pageController: widget.pageController,
            week: widget.week,
            format: widget.format,
            onHeaderTap: widget.onHeaderTap,
            onHeaderLongPress: widget.onHeaderLongPress,
          ),
          if (widget.format == CalendarFormat.month)
            FadeTransition(
              opacity: animation != null
                  ? Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    )
                  : const AlwaysStoppedAnimation(1),
              child: SizeTransition(
                sizeFactor: animation != null
                    ? Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      )
                    : const AlwaysStoppedAnimation(1),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    _buildSearchBar(colors),
                    const SizedBox(height: AppSpacing.md),
                    _buildMonthSelector(colors),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
      ),
      child: Builder(
        builder: (context) => AppPressable(
          onTap: () => context.go('/schedule/search'),
          semanticsLabel: context.l10n.search,
          child: Hero(
            tag: 'searchHero',
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppControlSize.touchTarget,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sectionGap,
                vertical: AppSpacing.gap,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  AppLineIconWidget(
                    AppLineIcon.search,
                    size: 18,
                    color: colors.muted,
                  ),
                  const SizedBox(width: AppSpacing.gap),
                  Text(
                    context.l10n.search,
                    style: AppText.body.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(AppColors colors) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final months = List.generate(12, (index) {
      final raw = DateFormat.MMM(
        locale,
      ).format(DateTime(2024, index + 1)).replaceAll('.', '');
      return raw.isEmpty
          ? '${index + 1}'
          : '${raw[0].toUpperCase()}${raw.substring(1)}';
    });
    const itemWidth = 68.0;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return SizedBox(
      height: AppControlSize.buttonMedium,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: months.length,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
        ),
        controller: _monthScrollController,
        itemBuilder: (context, index) {
          final isSelected = widget.day.month == index + 1;

          return AppPressable(
            haptics: !isSelected,
            onTap: isSelected ? null : () => widget.onMonthChanged(index + 1),
            semanticsLabel: DateFormat.yMMMM(
              locale,
            ).format(DateTime(2024, index + 1)),
            semanticsSelected: isSelected,
            child: SizedBox(
              width: itemWidth,
              child: Center(
                child: AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  constraints: const BoxConstraints(
                    minHeight: AppControlSize.touchTarget,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    months[index],
                    maxLines: 1,
                    style: AppText.subtext.copyWith(
                      color: isSelected ? colors.onAccent : colors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
