import 'dart:async';

import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:rtu_mirea_app/stories/view/stories_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_server_api/client.dart';
import 'package:collection/collection.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  static const int maxLessonsPerDay = 7;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final PageController _pageController;
  late final ScheduleBloc _bloc;

  final CalendarFormat _calendarFormat = CalendarFormat.week;

  // Timer to track the duration of the pull
  Timer? _toggleTimer;

  bool _isStoriesVisible = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: Calendar.getPageIndex(Calendar.getNowWithoutTime()),
    );
    _bloc = context.read<ScheduleBloc>();
  }

  @override
  void dispose() {
    _toggleTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  String get _appBarTitle {
    final scheduleState = context.read<ScheduleBloc>().state.selectedSchedule;

    switch (scheduleState.runtimeType) {
      case const (SelectedGroupSchedule):
        return (scheduleState as SelectedGroupSchedule).group.name;
      case const (SelectedTeacherSchedule):
        return _formatTeacherName((scheduleState as SelectedTeacherSchedule).teacher.name);
      case const (SelectedClassroomSchedule):
        return (scheduleState as SelectedClassroomSchedule).classroom.name;
      default:
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state.status == ScheduleStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при загрузке расписания'),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.status != ScheduleStatus.failure && current.selectedSchedule != null,
      builder: (context, state) {
        if (state.status == ScheduleStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.selectedSchedule == null) {
          return NoSelectedScheduleMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.status == ScheduleStatus.failure) {
          return LoadingErrorMessage(onTap: () {
            context.go('/schedule/search');
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_appBarTitle),
            actions: [
              _buildAddGroupButton(context),
              _buildSettingsButton(context),
              _buildComparisonModeButton(context), // Новая кнопка
              _buildViewToggleButton(),
            ],
          ),
          body: AnimatedSwitcher(
            duration: 300.ms,
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: state.isComparisonModeEnabled
                ? _buildComparisonMode(state)
                : (state.isListModeEnabled
                    ? KeyedSubtree(
                        key: const ValueKey('list_mode'),
                        child: _buildListMode(state),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('calendar_mode'),
                        child: _buildCalendarMode(state),
                      )),
          ),
          floatingActionButton: state.isComparisonModeEnabled
              ? Padding(
                  padding: const EdgeInsets.only(bottom: bottomNavigationBarHeight + 16.0),
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
  }

  Widget _buildAddGroupButton(BuildContext context) {
    return PlatformIconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedAddSquare,
        size: 24,
        color: AppTheme.colorsOf(context).active,
      ),
      material: (_, __) => MaterialIconButtonData(
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Добавить группу',
      ),
      onPressed: () => context.go('/schedule/search'),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return PlatformIconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedSettings02,
        size: 24,
        color: AppTheme.colorsOf(context).active,
      ),
      material: (_, __) => MaterialIconButtonData(
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Управление расписанием',
      ),
      onPressed: () => context.go('/profile'),
    );
  }

  Widget _buildComparisonModeButton(BuildContext context) {
    return PlatformIconButton(
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedAbacus,
        size: 24,
        color: AppTheme.colorsOf(context).active,
      ),
      material: (_, __) => MaterialIconButtonData(
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Сравнить расписания',
      ),
      onPressed: () {
        _bloc.add(const ToggleComparisonMode());
      },
    );
  }

  Widget _buildViewToggleButton() {
    return PlatformIconButton(
      onPressed: () {
        _bloc.add(const ToggleListMode());
      },
      material: (_, __) => MaterialIconButtonData(
        iconSize: 24,
        padding: const EdgeInsets.all(16.0),
        tooltip: 'Переключить вид',
      ),
      cupertino: (_, __) => CupertinoIconButtonData(
        padding: const EdgeInsets.all(16.0),
      ),
      icon: AnimatedSwitcher(
        duration: 300.ms,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: HugeIcon(
          key: ValueKey<bool>(_bloc.state.isListModeEnabled),
          icon: _bloc.state.isListModeEnabled ? HugeIcons.strokeRoundedListView : HugeIcons.strokeRoundedCalendar02,
          size: 24,
          color: AppTheme.colorsOf(context).active,
        ),
      ),
    );
  }

  void _openComparisonManager() {
    BottomModalSheet.show(
      context,
      child: const ComparisonManager(),
      title: 'Сравнение расписаний',
      description: 'Выберите до 4-х расписаний, чтобы сравнить их по дням',
    );
  }

  Map<DateTime, List<SchedulePart>> _groupLessonsByDay(List<SchedulePart> scheduleParts) {
    final Map<DateTime, List<SchedulePart>> lessonsByDay = {};

    for (final part in scheduleParts) {
      for (final date in part.dates) {
        final day = DateTime(date.year, date.month, date.day);
        lessonsByDay.update(
          day,
          (existing) => existing..add(part),
          ifAbsent: () => [part],
        );
      }
    }

    return Map.fromEntries(
      lessonsByDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  Widget _buildListMode(ScheduleState state) {
    final lessonsByDay = _groupLessonsByDay(state.selectedSchedule?.schedule ?? []);

    final today = Calendar.getNowWithoutTime();
    final filteredLessonsByDay = lessonsByDay.keys
        .where((day) => day.isAfter(today) || day.isAtSameMomentAs(today))
        .map((day) => MapEntry(day, lessonsByDay[day]))
        .toList();

    final storiesView = StoriesView(onStoriesLoaded: (stories) {
      if (stories.isNotEmpty && !_isStoriesVisible) {
        setState(() {
          _isStoriesVisible = true;
        });
      }
    });

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AnimatedOpacity(
              opacity: _isStoriesVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: storiesView,
            ),
          ),
        ),
        for (var entry in filteredLessonsByDay)
          _buildStickyHeader(entry.key, entry.value?.whereType<LessonSchedulePart>().toList() ?? []),
      ],
    );
  }

  Widget _buildStickyHeader(DateTime day, List<LessonSchedulePart> lessons) {
    return SliverStickyHeader(
      header: Container(
        color: AppTheme.colorsOf(context).background01,
        padding: const EdgeInsets.only(left: 22.0, bottom: 8.0, top: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              HugeIcons.strokeRoundedCalendar04,
              size: 17.5,
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEEE, d MMMM', 'ru').format(day),
              style: AppTextStyle.bodyBold,
            ),
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final lessonPart = lessons[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LessonCard(
                lesson: lessonPart,
                onTap: (lesson) {
                  context.go('/schedule/details', extra: (lesson, day));
                },
              ),
            );
          },
          childCount: lessons.length,
        ),
      ),
    );
  }

  Widget _buildCalendarMode(ScheduleState state) {
    return NestedScrollView(
      physics: const ClampingScrollPhysics(),
      headerSliverBuilder: (_, __) => [
        _buildSliverAppBar(),
        if (!state.isListModeEnabled)
          SliverToBoxAdapter(
            child: Calendar(
              pageViewController: _pageController,
              schedule: state.selectedSchedule?.schedule ?? [],
              comments: state.comments,
              showCommentsIndicators: state.showCommentsIndicators,
              calendarFormat: _calendarFormat,
            ),
          ),
      ],
      body: _buildPageView(state),
    );
  }

  Widget _buildSliverAppBar() {
    final storiesView = StoriesView(onStoriesLoaded: (stories) {
      if (stories.isNotEmpty && !_isStoriesVisible) {
        setState(() {
          _isStoriesVisible = true;
        });
      }
    });

    return SliverAppBar(
      pinned: false,
      primary: true,
      expandedHeight: 90,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedOpacity(
          opacity: _isStoriesVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: storiesView,
        ),
      ),
    );
  }

  Widget _buildPageView(ScheduleState state) {
    return EventsPageView(
      controller: _pageController,
      itemBuilder: (context, index) {
        final day = Calendar.firstCalendarDay.add(Duration(days: index));
        final lessonsForDay = Calendar.getSchedulePartsByDay(
          schedule: state.selectedSchedule?.schedule ?? [],
          day: day,
        );

        final holiday = lessonsForDay.firstWhereOrNull(
          (element) => element is HolidaySchedulePart,
        );

        if (holiday != null) {
          return HolidayPage(title: (holiday as HolidaySchedulePart).title);
        }

        if (day.weekday == DateTime.sunday) {
          return const HolidayPage(title: 'Выходной');
        }

        final lessonsByTime = groupBy<LessonSchedulePart, int>(
          lessonsForDay.whereType<LessonSchedulePart>().toList(),
          (lesson) => lesson.lessonBells.number,
        );

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: SchedulePage.maxLessonsPerDay,
          itemBuilder: (context, lessonIndex) {
            final lessons = lessonsByTime[lessonIndex + 1] ?? [];

            return lessons.isNotEmpty
                ? _buildLessonCard(lessons, lessons.first, day)
                : state.showEmptyLessons
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: EmptyLessonCard(lessonNumber: lessonIndex + 1),
                      )
                    : const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildLessonCard(List<LessonSchedulePart> lessons, LessonSchedulePart lesson, DateTime day) {
    return lessons.length == 1
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: LessonCard(
              lesson: lesson,
              onTap: (lesson) {
                context.go('/schedule/details', extra: (lesson, day));
              },
            ),
          )
        : ExpandablePageView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final currentLesson = lessons[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  Widget _buildComparisonMode(ScheduleState state) {
    if (state.comparisonSchedules.isEmpty) {
      return Center(
        child: Text(
          'Добавьте расписания для сравнения',
          style: AppTextStyle.body,
        ),
      );
    }

    final allLessons = state.comparisonSchedules
        .expand(
          (schedule) => schedule.schedule.whereType<LessonSchedulePart>(),
        )
        .toList();

    final lessonsByDay = _groupLessonsByDay(allLessons);

    return CustomScrollView(
      slivers: [
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Wrap(
        //       spacing: 16.0,
        //       runSpacing: 8.0,
        //       children: state.comparisonSchedules.toList().asMap().entries.map((entry) {
        //         final index = entry.key;
        //         final schedule = entry.value;
        //         final color = _getBackgroundColor(schedule);

        //         return Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Container(
        //               width: 16,
        //               height: 16,
        //               decoration: BoxDecoration(
        //                 color: color,
        //                 shape: BoxShape.circle,
        //               ),
        //             ),
        //             const SizedBox(width: 4),
        //             Text(
        //               _getScheduleTitle(schedule),
        //               style: AppTextStyle.captionL,
        //             ),
        //           ],
        //         );
        //       }).toList(),
        //     ),
        //   ),
        // ),
        for (var entry in lessonsByDay.entries)
          _buildComparisonStickyHeader(
              entry.key, entry.value.whereType<LessonSchedulePart>().toList(), state.comparisonSchedules.toList()),
      ],
    );
  }

  Widget _buildComparisonScheduleLegent(SelectedSchedule schedule) {
    final color = _getBackgroundColor(schedule);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _getScheduleTitle(schedule),
            style: AppTextStyle.captionL,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonStickyHeader(
    DateTime day,
    List<LessonSchedulePart> lessons,
    List<SelectedSchedule> schedules,
  ) {
    if (lessons.isEmpty) {
      return SliverStickyHeader(
        header: _buildDayHeader(day),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Пар нет',
              style: AppTextStyle.body.copyWith(
                color: AppTheme.colorsOf(context).active,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    final Map<SelectedSchedule, List<LessonSchedulePart>> lessonsPerSchedule = {
      for (var schedule in schedules)
        schedule: lessons
            .where(
              (lesson) => schedule.schedule.contains(lesson),
            )
            .toList()
    };

    final int maxLessons = _getMaxLessonsPerDay(schedules);

    return SliverStickyHeader(
      header: _buildDayHeader(day),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              columnWidths: {
                for (int i = 0; i < schedules.length; i++) i: const FixedColumnWidth(220),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                // Заголовки расписаний
                TableRow(
                  children: schedules.map((schedule) {
                    return _buildComparisonScheduleLegent(schedule);
                  }).toList(),
                ),
                // Строки уроков
                for (int lessonIndex = 0; lessonIndex < maxLessons; lessonIndex++)
                  TableRow(
                    children: schedules.map((schedule) {
                      final lesson = lessonsPerSchedule[schedule]?.firstWhereOrNull(
                        (lesson) => lesson.lessonBells.number == (lessonIndex + 1),
                      );
                      if (lesson != null) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(schedule),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: LessonCard(
                              lesson: lesson,
                              onTap: (lesson) {
                                context.go('/schedule/details', extra: (lesson, day));
                              },
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(schedule).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: EmptyLessonCard(lessonNumber: lessonIndex + 1),
                          ),
                        );
                      }
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(DateTime day) {
    return Container(
      color: AppTheme.colorsOf(context).background01,
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            HugeIcons.strokeRoundedCalendar04,
            size: 17.5,
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('EEEE, d MMMM', 'ru').format(day),
            style: AppTextStyle.bodyBold,
          ),
        ],
      ),
    );
  }

  /// Вспомогательные методы

  /// Проверяет, находятся ли две даты в один и тот же день
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Получает заголовок расписания
  String _getScheduleTitle(SelectedSchedule schedule) {
    return schedule is SelectedGroupSchedule
        ? schedule.group.name
        : schedule is SelectedTeacherSchedule
            ? _formatTeacherName(schedule.teacher.name)
            : schedule is SelectedClassroomSchedule
                ? schedule.classroom.name
                : 'Неизвестно';
  }

  /// Получает цвет фона для расписания
  Color _getBackgroundColor(SelectedSchedule schedule) {
    final index = _bloc.state.comparisonSchedules.toList().indexOf(schedule);
    final colors = [
      AppTheme.colors.colorful01.withOpacity(0.1),
      AppTheme.colors.colorful02.withOpacity(0.1),
      AppTheme.colors.colorful03.withOpacity(0.1),
      AppTheme.colors.colorful04.withOpacity(0.1),
      AppTheme.colors.colorful05.withOpacity(0.1),
      AppTheme.colors.colorful06.withOpacity(0.1),
      AppTheme.colors.colorful07.withOpacity(0.1),
    ];
    return colors[index % colors.length];
  }

  /// Получает максимальное количество уроков в день среди всех расписаний
  int _getMaxLessonsPerDay(List<SelectedSchedule> schedules) {
    int max = 0;
    for (var schedule in schedules) {
      final lessonsByDay = _groupLessonsByDay(schedule.schedule);
      for (var lessons in lessonsByDay.values) {
        if (lessons.length > max) max = lessons.length;
      }
    }
    return max;
  }
}
