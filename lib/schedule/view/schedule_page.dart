import 'dart:async';

import 'package:academic_calendar/academic_calendar.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/ads/ads.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/common/widgets/responsive_layout.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_server_api/client.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:rtu_mirea_app/navigation/view/scaffold_navigation_shell.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  static const int maxLessonsPerDay = 7;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final PageController _pageController;
  late final ScheduleBloc _bloc;

  // Track the current page index
  late int _currentPageIndex;

  CalendarFormat _calendarFormat = CalendarFormat.week;

  Timer? _toggleTimer;

  bool _isStoriesVisible = false;

  // Track scroll direction
  bool _isScrollingDown = false;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with the initial page
    _currentPageIndex = Calendar.getPageIndex(Calendar.getNowWithoutTime());
    _pageController = PageController(initialPage: _currentPageIndex);
    _bloc = context.read<ScheduleBloc>();

    // Add a listener to update current page index
    _pageController.addListener(_updateCurrentPage);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      // Only respond to vertical scrolling, ignore horizontal page changes
      if (notification.metrics.axis != Axis.vertical) return false;

      final ScrollMetrics metrics = notification.metrics;
      final double currentScrollPosition = metrics.pixels;

      final isScrollingDown = currentScrollPosition > _lastScrollPosition;

      if (isScrollingDown != _isScrollingDown) {
        setState(() {
          _isScrollingDown = isScrollingDown;
        });

        if (isScrollingDown) {
          BottomNavigationBarVisibilityController.instance.hide();
        } else {
          BottomNavigationBarVisibilityController.instance.show();
        }
      }

      _lastScrollPosition = currentScrollPosition;
    }

    return true;
  }

  void _updateCurrentPage() {
    if (_pageController.hasClients && _pageController.page != null) {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
      });
    }
  }

  @override
  void dispose() {
    _toggleTimer?.cancel();
    // Remove the listener when disposing
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    super.dispose();
  }

  String get _appBarTitle {
    final scheduleState = _bloc.state.selectedSchedule;
    if (scheduleState is SelectedGroupSchedule) {
      return scheduleState.group.name;
    } else if (scheduleState is SelectedTeacherSchedule) {
      return _formatTeacherName(scheduleState.teacher.name);
    } else if (scheduleState is SelectedClassroomSchedule) {
      return scheduleState.classroom.name;
    } else {
      return 'Расписание';
    }
  }

  String _formatTeacherName(String fullName) {
    final nameParts = fullName.split(' ');
    if (nameParts.length == 3) {
      return '${nameParts[0]} ${nameParts[1][0]}. ${nameParts[2][0]}.';
    } else if (nameParts.length == 2) {
      return '${nameParts[0]} ${nameParts[1][0]}.';
    } else {
      return fullName;
    }
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = ResponsiveLayout.isDesktop(context);

    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, state) {
        return BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state.status == ScheduleStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Ошибка при загрузке расписания')));
            }
          },
          buildWhen:
              (previous, current) => current.status != ScheduleStatus.failure && current.selectedSchedule != null,
          builder: (context, state) {
            if (state.status == ScheduleStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.selectedSchedule == null) {
              return isWideScreen
                  ? const DesktopNoScheduleView()
                  : NoSelectedScheduleMessage(
                    onTap: () {
                      context.go('/schedule/search');
                    },
                  );
            } else if (state.status == ScheduleStatus.failure) {
              return LoadingErrorMessage(
                onTap: () {
                  context.go('/schedule/search');
                },
              );
            }

            // Enhanced desktop view experience
            if (isWideScreen) {
              return _buildDesktopLayout(state);
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(_appBarTitle),
                actions: [
                  // Add custom schedules button
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Мои расписания',
                    onPressed: () => context.go('/schedule/custom'),
                  ),
                  ComparisonModeButton(onPressed: () => _bloc.add(const ToggleComparisonMode())),
                  ViewToggleButton(
                    isListModeEnabled: _bloc.state.isListModeEnabled,
                    onPressed: () => _bloc.add(const ToggleListMode()),
                  ),
                ],
              ),
              body: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: AnimatedSwitcher(
                  duration: 300.ms,
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)),
                        child: child,
                      ),
                    );
                  },
                  child:
                      state.isComparisonModeEnabled
                          ? _ComparisonModeView(onOpenComparisonManager: _openComparisonManager)
                          : state.isListModeEnabled
                          ? _ListModeView(isStoriesVisible: _isStoriesVisible, onStoriesLoaded: _handleStoriesLoaded)
                          : _CalendarModeView(
                            pageController: _pageController,
                            calendarFormat: _calendarFormat,
                            onFormatChanged: _onFormatChanged,
                            isStoriesVisible: _isStoriesVisible,
                            onStoriesLoaded: _handleStoriesLoaded,
                          ),
                ),
              ),
              floatingActionButton:
                  state.isComparisonModeEnabled
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: bottomNavigationBarHeight + AppSpacing.lg),
                        child: FloatingActionButton(
                          onPressed: _openComparisonManager,
                          tooltip: 'Управление сравнениями',
                          child: const Icon(Icons.compare),
                        ),
                      )
                      : null,
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopLayout(ScheduleState state) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // Use the tracked page index instead of directly accessing _pageController.page
    final selectedDay = Calendar.firstCalendarDay.add(Duration(days: _currentPageIndex));
    final currentWeek = getWeek(selectedDay);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Row(
          children: [
            // Main content area with calendar and lessons
            Expanded(
              child: Column(
                children: [
                  // App bar with title and navigation
                  DesktopAppBar(
                    title: _appBarTitle,
                    scheduleType: _getScheduleTypeLabel(state.selectedSchedule!),
                    selectedDay: selectedDay,
                    onTodayPressed: () {
                      final todayIndex = Calendar.getPageIndex(Calendar.getNowWithoutTime());
                      _pageController.animateToPage(
                        todayIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onWeekSelectPressed: () {
                      Calendar.showWeekSelector(context, currentWeek, (week) {
                        final currentDate = Calendar.getNowWithoutTime();
                        final newFocusedDay = CalendarUtils.getDaysInWeek(week, currentDate).first;
                        final newPage = Calendar.getPageIndex(newFocusedDay);

                        _pageController.animateToPage(
                          newPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    onPreviousDay: () {
                      final currentPage = _pageController.page?.round() ?? _pageController.initialPage;
                      _pageController.animateToPage(
                        currentPage - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onNextDay: () {
                      final currentPage = _pageController.page?.round() ?? _pageController.initialPage;
                      _pageController.animateToPage(
                        currentPage + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),

                  // Main content with calendar and lessons
                  Expanded(
                    child:
                        state.isComparisonModeEnabled
                            ? _ComparisonModeView(onOpenComparisonManager: _openComparisonManager)
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Calendar panel
                                Container(
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    border: Border(right: BorderSide(color: colors.background03)),
                                  ),
                                  child: DesktopCalendarPanel(
                                    pageController: _pageController,
                                    calendarFormat: _calendarFormat,
                                    onFormatChanged: _onFormatChanged,
                                    isStoriesVisible: _isStoriesVisible,
                                    onStoriesLoaded: _handleStoriesLoaded,
                                    schedule: state.selectedSchedule?.schedule ?? [],
                                    comments: state.comments,
                                    showCommentsIndicators: state.showCommentsIndicators,
                                  ),
                                ),

                                // Lessons and analytics area
                                Expanded(
                                  child:
                                      state.isListModeEnabled
                                          ? _ListModeView(isStoriesVisible: false, onStoriesLoaded: (_) {})
                                          : DesktopScheduleContent(
                                            pageController: _pageController,
                                            showEmptyLessons: state.showEmptyLessons,
                                            showAnalytics: state.showAnalytics,
                                            schedule: state.selectedSchedule?.schedule ?? [],
                                            selectedDay: selectedDay,
                                          ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          state.isComparisonModeEnabled
              ? FloatingActionButton(
                onPressed: _openComparisonManager,
                tooltip: 'Управление сравнениями',
                child: const Icon(Icons.compare),
              )
              : null,
    );
  }

  Widget _buildDesktopHeaderButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: IconButton(
          icon: Icon(icon, color: isActive ? colors.primary : colors.active),
          style: IconButton.styleFrom(
            backgroundColor: isActive ? colors.primary.withOpacity(0.1) : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  String _getScheduleTypeLabel(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return 'Группа';
    } else if (schedule is SelectedTeacherSchedule) {
      return 'Преподаватель';
    } else if (schedule is SelectedClassroomSchedule) {
      return 'Аудитория';
    }
    return '';
  }

  void _openComparisonManager() {
    BottomModalSheet.show(
      context,
      child: const ComparisonManager(),
      title: 'Сравнение расписаний',
      description: 'Выберите до 4-х расписаний, чтобы сравнить их по дням',
    );
  }

  void _handleStoriesLoaded(bool hasStories) {
    if (hasStories && !_isStoriesVisible) {
      setState(() {
        _isStoriesVisible = true;
      });
    }
  }
}

class _ListModeView extends StatelessWidget {
  const _ListModeView({required this.isStoriesVisible, required this.onStoriesLoaded});

  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScheduleBloc bloc) => bloc.state);
    final scheduleParts = state.selectedSchedule?.schedule ?? [];
    final lessonsByDay = _groupLessonsByDay(scheduleParts);
    final today = Calendar.getNowWithoutTime();
    final filteredLessonsByDay =
        lessonsByDay.keys
            .where((day) => day.isAfter(today) || day.isAtSameMomentAs(today))
            .map((day) => MapEntry(day, lessonsByDay[day]))
            .toList();
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: StickyAd()),
        for (var entry in filteredLessonsByDay)
          StickyHeader(day: entry.key, lessons: entry.value?.whereType<LessonSchedulePart>().toList() ?? []),
      ],
    );
  }

  Map<DateTime, List<SchedulePart>> _groupLessonsByDay(List<SchedulePart> scheduleParts) {
    final Map<DateTime, List<SchedulePart>> lessonsByDay = {};
    for (final part in scheduleParts) {
      for (final date in part.dates) {
        final day = DateTime(date.year, date.month, date.day);
        lessonsByDay.update(day, (existing) => existing..add(part), ifAbsent: () => [part]);
      }
    }
    return Map.fromEntries(lessonsByDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}

class _CalendarModeView extends StatelessWidget {
  const _CalendarModeView({
    required this.pageController,
    required this.calendarFormat,
    required this.onFormatChanged,
    required this.isStoriesVisible,
    required this.onStoriesLoaded,
  });

  final PageController pageController;
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScheduleBloc bloc) => bloc.state);
    return NestedScrollView(
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder:
          (_, __) => [
            CalendarStoriesAppBar(isStoriesVisible: isStoriesVisible, onStoriesLoaded: onStoriesLoaded),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Calendar(
                    pageViewController: pageController,
                    schedule: state.selectedSchedule?.schedule ?? [],
                    comments: state.comments,
                    showCommentsIndicators: state.showCommentsIndicators,
                    calendarFormat: calendarFormat,
                  ),
                ],
              ),
            ),
          ],
      body: _EventsPageView(pageController: pageController, showEmptyLessons: state.showEmptyLessons),
    );
  }
}

class _EventsPageView extends StatelessWidget {
  const _EventsPageView({required this.pageController, required this.showEmptyLessons});

  final PageController pageController;
  final bool showEmptyLessons;

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String _pluralizeWindow(int count) {
    return Intl.plural(count, one: '$count пару', few: '$count пары', many: '$count пар', other: '$count пар');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScheduleBloc bloc) => bloc.state);
    final schedule = state.selectedSchedule?.schedule ?? [];
    return EventsPageView(
      controller: pageController,
      itemBuilder: (context, index) {
        final day = Calendar.firstCalendarDay.add(Duration(days: index));
        final lessonsForDay = Calendar.getSchedulePartsByDay(schedule: schedule, day: day);
        final holiday = lessonsForDay.firstWhereOrNull((element) => element is HolidaySchedulePart);
        if (holiday != null) return HolidayPage(title: (holiday as HolidaySchedulePart).title);
        if (day.weekday == DateTime.sunday) return const HolidayPage(title: 'Выходной');
        final allLessons = lessonsForDay.whereType<LessonSchedulePart>().toList();
        final numberedLessons = allLessons.where((l) => l.lessonBells.number != null).toList();
        final unnumberedLessons = allLessons.where((l) => l.lessonBells.number == null).toList();
        numberedLessons.sort(
          (a, b) => _toMinutes(a.lessonBells.startTime).compareTo(_toMinutes(b.lessonBells.startTime)),
        );
        unnumberedLessons.sort(
          (a, b) => _toMinutes(a.lessonBells.startTime).compareTo(_toMinutes(b.lessonBells.startTime)),
        );
        final lessonsByTime = <int, List<LessonSchedulePart>>{};
        for (final l in numberedLessons) {
          final key = l.lessonBells.number!;
          lessonsByTime.putIfAbsent(key, () => []).add(l);
        }
        for (final l in unnumberedLessons) {
          final lessonTime = _toMinutes(l.lessonBells.startTime);
          LessonSchedulePart? previous;
          LessonSchedulePart? next;
          for (final nl in numberedLessons) {
            final t = _toMinutes(nl.lessonBells.startTime);
            if (t <= lessonTime) previous = nl;
            if (t > lessonTime) {
              next = nl;
              break;
            }
          }
          final key =
              previous != null && next != null
                  ? (lessonTime - _toMinutes(previous.lessonBells.startTime) <=
                          _toMinutes(next.lessonBells.startTime) - lessonTime
                      ? previous.lessonBells.number!
                      : next.lessonBells.number!)
                  : previous?.lessonBells.number ?? next?.lessonBells.number ?? 0;
          if (key != 0) {
            lessonsByTime.putIfAbsent(key, () => []).add(l);
          }
        }
        if (showEmptyLessons) {
          final List<Widget> widgets = [];
          final scheduledKeys = lessonsByTime.keys.where((k) => k != 0).toList()..sort();
          for (var lessonNumber = 1; lessonNumber <= SchedulePage.maxLessonsPerDay; lessonNumber++) {
            final lessons = lessonsByTime[lessonNumber] ?? [];
            if (lessons.isNotEmpty) {
              widgets.add(_buildLessonCard(context, lessons, day));
            } else {
              widgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: EmptyLessonCard(lessonNumber: lessonNumber),
                ),
              );
            }
            if (scheduledKeys.contains(lessonNumber)) {
              final indexInScheduled = scheduledKeys.indexOf(lessonNumber);
              if (indexInScheduled < scheduledKeys.length - 1) {
                final nextKey = scheduledKeys[indexInScheduled + 1];
                if (nextKey - lessonNumber == 1) {
                  widgets.add(
                    ConsecutiveBreakWidget(
                      currentLessons: lessonsByTime[lessonNumber]!,
                      nextLessons: lessonsByTime[nextKey]!,
                    ),
                  );
                }
              }
            }
          }
          return ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: widgets);
        } else {
          final sortedKeys = lessonsByTime.keys.where((k) => k != 0).toList()..sort();
          final List<Widget> widgets = [];
          for (var i = 0; i < sortedKeys.length; i++) {
            final key = sortedKeys[i];
            final lessons = lessonsByTime[key]!;
            widgets.add(_buildLessonCard(context, lessons, day));
            if (i < sortedKeys.length - 1) {
              final int currentKey = sortedKeys[i];
              final int nextKey = sortedKeys[i + 1];
              if (nextKey - currentKey == 1) {
                widgets.add(
                  ConsecutiveBreakWidget(
                    currentLessons: lessonsByTime[currentKey]!,
                    nextLessons: lessonsByTime[nextKey]!,
                  ),
                );
              } else {
                final windowCount = nextKey - currentKey - 1;
                widgets.add(WindowBreakWidget(windowCount: windowCount));
              }
            }
          }
          return ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: widgets);
        }
      },
    );
  }

  Widget _buildLessonCard(BuildContext context, List<LessonSchedulePart> lessons, DateTime day) {
    if (lessons.length == 1) {
      final lesson = lessons.first;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        child: LessonCard(
          lesson: lesson,
          onTap: (lesson) {
            context.go('/schedule/details', extra: (lesson, day));
          },
        ),
      );
    }
    return ExpandablePageView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final currentLesson = lessons[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: LessonCard(
            countInGroup: lessons.length,
            indexInGroup: index,
            lesson: currentLesson,
            onTap: (lesson) {
              context.go('/schedule/details', extra: (lesson, day));
            },
          ),
        );
      },
    );
  }
}

class _ComparisonModeView extends StatelessWidget {
  const _ComparisonModeView({required this.onOpenComparisonManager});

  final VoidCallback onOpenComparisonManager;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScheduleBloc bloc) => bloc.state);
    final comparisonSchedules = state.comparisonSchedules;
    if (comparisonSchedules.isEmpty) {
      return Center(child: Text('Добавьте расписания для сравнения', style: AppTextStyle.body));
    }
    final allLessons =
        comparisonSchedules.expand((schedule) => schedule.schedule.whereType<LessonSchedulePart>()).toList();
    final lessonsByDay = _groupLessonsByDay(allLessons);
    final today = Calendar.getNowWithoutTime();
    final filteredLessonsByDay =
        lessonsByDay.keys
            .where((day) => day.isAfter(today) || day.isAtSameMomentAs(today))
            .map((day) => MapEntry(day, lessonsByDay[day]))
            .toList();
    return CustomScrollView(
      slivers: [
        for (var entry in filteredLessonsByDay)
          ComparisonStickyHeader(day: entry.key, lessons: entry.value ?? [], schedules: comparisonSchedules.toList()),
      ],
    );
  }

  Map<DateTime, List<SchedulePart>> _groupLessonsByDay(List<LessonSchedulePart> scheduleParts) {
    final Map<DateTime, List<SchedulePart>> lessonsByDay = {};
    for (final part in scheduleParts) {
      for (final date in part.dates) {
        final day = DateTime(date.year, date.month, date.day);
        lessonsByDay.update(day, (existing) => existing..add(part), ifAbsent: () => [part]);
      }
    }
    return Map.fromEntries(lessonsByDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}
