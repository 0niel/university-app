import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/stories/view/stories_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicons/unicons.dart';
import 'package:university_app_server_api/client.dart';
import 'package:collection/collection.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final PageController _schedulePageController;

  @override
  void initState() {
    super.initState();
    _schedulePageController = PageController(
      initialPage: Calendar.getPageIndex(Calendar.getNowWithoutTime()),
    );
  }

  @override
  void dispose() {
    _schedulePageController.dispose();
    super.dispose();
  }

  String get _getAppBarTitle {
    final schedule = context.read<ScheduleBloc>().state.selectedSchedule;

    if (schedule is SelectedGroupSchedule) {
      return 'Расписание ${schedule.group.name}';
    } else if (schedule is SelectedTeacherSchedule) {
      final splittedName = schedule.teacher.name.split(' ');
      if (splittedName.length == 3) {
        return 'Расписание ${splittedName[0]} ${splittedName[1][0]}. ${splittedName[2][0]}.';
      } else if (splittedName.length == 2) {
        return 'Расписание ${splittedName[0]} ${splittedName[1][0]}.';
      } else {
        return 'Расписание ${schedule.teacher.name}';
      }
    } else if (schedule is SelectedClassroomSchedule) {
      return 'Расписание ${schedule.classroom.name}';
    } else {
      return 'Расписание';
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
        if (state.selectedSchedule == null && state.status != ScheduleStatus.loading) {
          return NoSelectedScheduleMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.status == ScheduleStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == ScheduleStatus.failure && state.selectedSchedule == null) {
          return LoadingErrorMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.selectedSchedule != null) {
          return Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool isWideScreen = constraints.maxWidth > 880;

                final eventsPageView = EventsPageView(
                  controller: _schedulePageController,
                  itemBuilder: (context, index) {
                    final day = Calendar.firstCalendarDay.add(Duration(days: index));
                    final schedules = Calendar.getSchedulePartsByDay(
                      schedule: state.selectedSchedule?.schedule ?? [],
                      day: day,
                    );

                    final holiday = schedules.firstWhereOrNull(
                      (element) => element is HolidaySchedulePart,
                    );

                    if (holiday != null) {
                      return HolidayPage(title: (holiday as HolidaySchedulePart).title);
                    }

                    if (day.weekday == DateTime.sunday) {
                      return const HolidayPage(title: 'Выходной');
                    }

                    final lessons = schedules.whereType<LessonSchedulePart>().toList();
                    final lessonsByTime = groupBy<LessonSchedulePart, int>(
                      lessons,
                      (lesson) => lesson.lessonBells.number,
                    );

                    const maxLessonCountInDay = 6;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: maxLessonCountInDay,
                      itemBuilder: (context, index) {
                        final lessons = List<LessonSchedulePart>.from(
                          (lessonsByTime.containsKey(index + 1) ? lessonsByTime[index + 1] : []) as Iterable,
                        );
                        final lesson = lessons.isNotEmpty ? lessons.first : null;

                        if (lesson != null) {
                          return _buildLessonCard(lessons, lesson, day);
                        }

                        if (state.showEmptyLessons) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: EmptyLessonCard(lessonNumber: index + 1),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                );

                return BlocBuilder<StoriesBloc, StoriesState>(
                  builder: (context, storiesState) {
                    return NestedScrollView(
                      headerSliverBuilder: (_, __) => [
                        SliverAppBar(
                          pinned: false,
                          title: Text(
                            _getAppBarTitle,
                          ),
                          actions: [
                            _buildStoriesAddButton(context),
                            _buildSettingsButton(context),
                          ],
                          bottom: (storiesState is StoriesLoaded && storiesState.stories.isNotEmpty)
                              ? const PreferredSize(
                                  preferredSize: Size.fromHeight(80),
                                  child: StoriesView(),
                                )
                              : const PreferredSize(
                                  preferredSize: Size.fromHeight(0),
                                  child: SizedBox.shrink(),
                                ),
                        ),
                        if (!isWideScreen)
                          SliverToBoxAdapter(
                            child: Calendar(
                              pageViewController: _schedulePageController,
                              schedule: state.selectedSchedule?.schedule ?? [],
                              comments: state.comments,
                              showCommentsIndicators: state.showCommentsIndicators,
                            ),
                          ),
                      ],
                      body: isWideScreen
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: eventsPageView,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: _buildCalendar(context, state),
                                ),
                              ],
                            )
                          : eventsPageView,
                    );
                  },
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildLessonCard(List<LessonSchedulePart> lessons, LessonSchedulePart lesson, DateTime day) {
    return lessons.length == 1
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: LessonCard(
              lesson: lesson,
              onTap: (lesson) {
                context.go(
                  '/schedule/details',
                  extra: (lesson, day),
                );
              },
            ),
          )
        : ExpandablePageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: LessonCard(
                  countInGroup: lessons.length,
                  indexInGroup: index,
                  lesson: lesson,
                  onTap: (lesson) {
                    context.go(
                      '/schedule/details',
                      extra: (lesson, day),
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: IconButton(
        icon: Icon(
          UniconsLine.cog,
          color: AppTheme.colorsOf(context).active,
        ),
        tooltip: 'Управление расписанием',
        onPressed: () {
          BottomModalSheet.show(
            context,
            child: const SettingsMenu(),
            title: 'Управление расписанием',
            description:
                'Редактирование сохраненных расписаний и добавление новых, а также настройки отображения расписания.',
            backgroundColor: AppTheme.colorsOf(context).background03,
          );
        },
      ),
    );
  }

  Widget _buildStoriesAddButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        UniconsLine.plus_circle,
        color: AppTheme.colorsOf(context).active,
      ),
      tooltip: 'Добавить историю',
      onPressed: () {
        context.go('/stories/add');
      },
    );
  }

  Widget _buildCalendar(BuildContext context, ScheduleState state) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 466,
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.colorsOf(context).deactiveDarker,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Calendar(
          pageViewController: _schedulePageController,
          schedule: state.selectedSchedule?.schedule ?? [],
          comments: state.comments,
          showCommentsIndicators: state.showCommentsIndicators,
          calendarFormat: CalendarFormat.month,
          canChangeFormat: false,
        ),
      ),
    );
  }
}
