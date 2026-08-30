import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_window.dart';

part 'home_day_cell.dart';

class HomeDayPager extends StatefulWidget {
  const HomeDayPager({
    required this.days,
    required this.lessonCounts,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<DateTime> days;
  final List<int> lessonCounts;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<HomeDayPager> createState() => _HomeDayPagerState();
}

class _HomeDayPagerState extends State<HomeDayPager> {
  static const _leadingInset = 2.0;

  final ScrollController _controller = ScrollController();

  bool get _accessible => MediaQuery.textScalerOf(context).scale(1) >= 1.6;

  double get _cellWidth => _accessible ? 88 : 48;

  double get _separator => _accessible ? 4 : 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _revealSelected(animate: false),
    );
  }

  @override
  void didUpdateWidget(HomeDayPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _revealSelected(animate: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _revealSelected({required bool animate}) {
    if (!mounted || !_controller.hasClients) return;
    final position = _controller.position;
    if (!position.hasViewportDimension || !position.hasContentDimensions) {
      return;
    }
    final offset = homeDayRailOffset(
      index: widget.selectedIndex,
      cellWidth: _cellWidth,
      separator: _separator,
      leadingInset: _leadingInset,
      viewport: position.viewportDimension,
      maxScrollExtent: position.maxScrollExtent,
    );
    if ((offset - position.pixels).abs() < 1) return;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (!animate || reduceMotion) {
      _controller.jumpTo(offset);
      return;
    }
    unawaited(
      _controller.animateTo(
        offset,
        duration: NinjaMotion.base,
        curve: NinjaMotion.enter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final accessible = _accessible;
    return SizedBox(
      height: accessible ? 76 : 62,
      child: ListView.separated(
        key: const ValueKey('home-day-strip'),
        controller: _controller,
        padding: const EdgeInsets.symmetric(horizontal: _leadingInset),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.days.length,
        separatorBuilder: (_, _) => SizedBox(width: _separator),
        itemBuilder: (context, index) => SizedBox(
          width: _cellWidth,
          child: _HomeDayCell(
            day: widget.days[index],
            locale: locale,
            lessonCount: widget.lessonCounts.elementAtOrNull(index) ?? 0,
            selected: index == widget.selectedIndex,
            accessible: accessible,
            onTap: () => widget.onSelected(index),
          ),
        ),
      ),
    );
  }
}
