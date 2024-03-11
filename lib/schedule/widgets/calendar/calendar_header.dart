import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicons/unicons.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({Key? key, required this.day, required this.format, required this.pageController})
      : super(key: key);

  final DateTime day;
  final CalendarFormat format;
  final PageController? pageController;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 12,
      vsync: this,
    );

    final currentMonth = widget.day.month;
    final initialDay = Calendar.firstCalendarDay;
    _tabController.animateTo(currentMonth - 1);

    widget.pageController?.addListener(() {
      final currentPage = widget.pageController?.page?.toInt() ?? 0;
      final currentMonth = initialDay.add(Duration(days: currentPage)).month;
      if (_tabController.index != currentMonth - 1) _tabController.animateTo(currentMonth - 1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 11),
        _CalendarWeeksHeader(day: widget.day, pageController: widget.pageController),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0,
            widget.format == CalendarFormat.month ? 5 : 0,
            0,
          ),
          child: Column(children: [
            if (widget.format == CalendarFormat.month)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(0.12),
                            width: 1,
                          ),
                          backgroundColor: AppTheme.colorsOf(context).background02,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        onPressed: () {
                          context.go('/schedule/search');
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 9),
                              child: Icon(
                                UniconsLine.search,
                                size: 20,
                                color: AppTheme.colorsOf(context).deactive,
                              ),
                            ),
                            Text(
                              "Поиск по расписанию",
                              style: AppTextStyle.bodyL.copyWith(
                                color: AppTheme.colorsOf(context).deactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(
                    height: 0,
                    indent: 12,
                    endIndent: 12,
                  ),
                  const SizedBox(height: 12),
                  Stack(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 58),
                      child: Divider(
                        height: 0,
                        indent: 24,
                        endIndent: 24,
                      ),
                    ),
                    DefaultTabController(
                      length: 12,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        physics: LockScrollPhysics(lockLeft: true, lockRight: true),
                        labelStyle: AppTextStyle.bodyBold,
                        unselectedLabelStyle: AppTextStyle.bodyL,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        labelColor: AppTheme.colorsOf(context).primary,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelColor: AppTheme.colorsOf(context).deactive,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 1,
                            color: AppTheme.colorsOf(context).primary,
                          ),
                        ),
                        tabs: const [
                          Tab(text: 'Январь'),
                          Tab(text: 'Февраль'),
                          Tab(text: 'Март'),
                          Tab(text: 'Апрель'),
                          Tab(text: 'Май'),
                          Tab(text: 'Июнь'),
                          Tab(text: 'Июль'),
                          Tab(text: 'Август'),
                          Tab(text: 'Сентябрь'),
                          Tab(text: 'Октябрь'),
                          Tab(text: 'Ноябрь'),
                          Tab(text: 'Декабь'),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
          ]),
        ),
      ],
    );
  }
}

class _CalendarWeeksHeader extends StatelessWidget {
  const _CalendarWeeksHeader({Key? key, required this.day, required this.pageController}) : super(key: key);

  final DateTime day;
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 38,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: AppTheme.colorsOf(context).active,
              ),
              onPressed: () {
                pageController?.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
          AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              key: ValueKey<String>(DateFormat.yMMMM('ru_RU').format(day)),
              children: [
                Text(
                  DateFormat.yMMMM('ru_RU').format(day)[0].toUpperCase() +
                      DateFormat.yMMMM('ru_RU').format(day).substring(1).replaceAll(RegExp(r' г.'), ' '),
                  style: AppTextStyle.bodyL,
                ),
                const SizedBox(width: 5.50),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.colorsOf(context).active,
                  ),
                ),
                const SizedBox(width: 5.50),
                Text("12 неделя", style: AppTextStyle.bodyL),
              ],
            ),
          ),
          SizedBox(
            width: 38,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                pageController?.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppTheme.colorsOf(context).active,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
