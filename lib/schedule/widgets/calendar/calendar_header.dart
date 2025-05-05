import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicons/unicons.dart';
import 'package:rtu_mirea_app/common/widgets/responsive_layout.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    super.key,
    required this.day,
    required this.week,
    required this.format,
    required this.pageController,
    required this.onMonthChanged,
    this.onHeaderTap,
    this.onHeaderLongPress,
    this.animationController,
    this.onYearChanged,
  });

  final DateTime day;
  final int week;
  final CalendarFormat format;
  final PageController? pageController;
  final ValueSetter<int> onMonthChanged;
  final ValueSetter<int>? onYearChanged;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onHeaderLongPress;
  final AnimationController? animationController;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _yearScrollController;
  int _currentYear = DateTime.now().year;
  final List<int> _availableYears = List.generate(5, (index) => DateTime.now().year - 2 + index);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(initialIndex: widget.day.month - 1, length: 12, vsync: this);

    _yearScrollController = ScrollController();
    _currentYear = widget.day.year;

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (widget.day.month == _tabController.index + 1) return;
      widget.onMonthChanged(_tabController.index + 1);
    });
  }

  @override
  void didUpdateWidget(covariant CalendarHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.day.month != widget.day.month) {
      _tabController.animateTo(widget.day.month - 1);
    }

    if (oldWidget.day.year != widget.day.year) {
      setState(() {
        _currentYear = widget.day.year;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isWideScreen = ResponsiveLayout.isDesktop(context) || ResponsiveLayout.isTablet(context);

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          isWideScreen
              ? _buildDesktopHeader(colors)
              : _CalendarWeeksHeader(
                day: widget.day,
                pageController: widget.pageController,
                week: widget.week,
                format: widget.format,
                onHeaderTap: widget.onHeaderTap,
                onHeaderLongPress: widget.onHeaderLongPress,
              ),
          if (widget.format == CalendarFormat.month)
            FadeTransition(
              opacity:
                  widget.animationController != null
                      ? Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(parent: widget.animationController!, curve: Curves.easeInOut))
                      : const AlwaysStoppedAnimation(1.0),
              child: SizeTransition(
                sizeFactor:
                    widget.animationController != null
                        ? Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(parent: widget.animationController!, curve: Curves.easeInOut))
                        : const AlwaysStoppedAnimation(1.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildSearchBar(colors, isWideScreen),
                    const SizedBox(height: 12),
                    _buildMonthSelector(colors),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(AppColors colors) {
    final currentYear = widget.day.year;
    final currentMonth = DateFormat.MMMM('ru_RU').format(widget.day);
    final currentDay = widget.day.day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.background03.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month and year display with improved styling
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: colors.active,
            onPressed: () {
              if (widget.pageController != null) {
                widget.pageController!.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),

          Expanded(child: Center(child: _buildHeaderTitle(context, colors, widget.format == CalendarFormat.month))),

          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: colors.active,
            onPressed: () {
              if (widget.pageController != null) {
                widget.pageController!.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(AppColors colors, String title, CalendarFormat format) {
    final isSelected = widget.format == format;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        if (widget.format != format) {
          final newFormat = format;
          final currentContext = context;

          // Using Future.delayed to avoid build phase errors
          Future.delayed(Duration.zero, () {
            if (currentContext.mounted) {
              widget.onYearChanged?.call(_currentYear);
              widget.onMonthChanged(widget.day.month);
              widget.pageController?.animateToPage(
                format == CalendarFormat.week ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: AppTextStyle.captionL.copyWith(
            color: isSelected ? Colors.white : colors.deactive,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppColors colors, bool isWideScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 24 : 16),
      child: SizedBox(
        height: 40,
        child: PlatformTextButton(
          material:
              (_, __) => MaterialTextButtonData(
                style: TextButton.styleFrom(
                  backgroundColor: colors.background02,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
              ),
          cupertino:
              (_, __) => CupertinoTextButtonData(padding: EdgeInsets.zero, borderRadius: BorderRadius.circular(10)),
          color: colors.background02,
          onPressed: () {
            context.go('/schedule/search');
          },
          child: Hero(
            tag: 'searchHero',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 9),
                  child: Icon(UniconsLine.search, size: 18, color: colors.deactive),
                ),
                Text("Поиск по расписанию", style: AppTextStyle.body.copyWith(color: colors.deactive)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(AppColors colors) {
    final months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
    const itemWidth = 55.0;
    final selectedIndex = widget.day.month - 1;
    final isWideScreen = ResponsiveLayout.isDesktop(context) || ResponsiveLayout.isTablet(context);

    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: months.length,
        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 24 : 16),
        controller: ScrollController(initialScrollOffset: selectedIndex > 2 ? (selectedIndex - 2) * itemWidth : 0),
        itemBuilder: (context, index) {
          final isSelected = widget.day.month == index + 1;

          return GestureDetector(
            onTap: () => widget.onMonthChanged(index + 1),
            child: Container(
              width: itemWidth,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  months[index],
                  style: AppTextStyle.captionL.copyWith(
                    color: isSelected ? Colors.white : colors.deactive,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, AppColors colors, bool isMonthView) {
    return GestureDetector(
      onTap: widget.onHeaderTap,
      onLongPress: widget.onHeaderLongPress,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMonthView) ...[
              Text(
                "${DateFormat.MMM('ru_RU').format(widget.day)[0].toUpperCase()}${DateFormat.MMM('ru_RU').format(widget.day).substring(1)} ${widget.day.year}",
                style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Container(width: 3, height: 3, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.deactive)),
              const SizedBox(width: 6),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: colors.active),
                const SizedBox(width: 4),
                Text(
                  '${widget.week} неделя',
                  style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600, color: colors.active),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, AppColors colors, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(4),
      child: PlatformTextButton(
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(color: colors.background03.withOpacity(0.5), shape: BoxShape.circle),
          child: Center(child: HugeIcon(icon: icon, color: colors.active, size: 16)),
        ),
      ),
    );
  }
}

class _CalendarWeeksHeader extends StatelessWidget {
  const _CalendarWeeksHeader({
    required this.day,
    required this.pageController,
    required this.week,
    required this.format,
    this.onHeaderTap,
    this.onHeaderLongPress,
  });

  final DateTime day;
  final int week;
  final CalendarFormat format;
  final PageController? pageController;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onHeaderLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isMonthView = format == CalendarFormat.month;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color:
            isMonthView
                ? null
                : isLight
                ? colors.surfaceHigh
                : colors.background02.withOpacity(0.2),
        borderRadius: isMonthView ? null : BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!ResponsiveLayout.isDesktop(context))
            _buildNavButton(context, HugeIcons.strokeRoundedArrowLeft01, colors, () {
              pageController?.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }),
          Expanded(child: _buildHeaderTitle(context, colors, isMonthView)),
          if (!ResponsiveLayout.isDesktop(context))
            _buildNavButton(context, HugeIcons.strokeRoundedArrowRight01, colors, () {
              pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, AppColors colors, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(4),
      child: PlatformTextButton(
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(color: colors.background03.withOpacity(0.5), shape: BoxShape.circle),
          child: Center(child: HugeIcon(icon: icon, color: colors.active, size: 16)),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, AppColors colors, bool isMonthView) {
    return GestureDetector(
      onTap: onHeaderTap,
      onLongPress: onHeaderLongPress,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMonthView) ...[
              Text(
                "${DateFormat.MMM('ru_RU').format(day)[0].toUpperCase()}${DateFormat.MMM('ru_RU').format(day).substring(1)} ${day.year}",
                style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Container(width: 3, height: 3, decoration: BoxDecoration(shape: BoxShape.circle, color: colors.deactive)),
              const SizedBox(width: 6),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  '$week неделя',
                  style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600, color: colors.active),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
