import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/empty_lesson_card.dart';
import 'lesson_card.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'story_item.dart';

class SchedulePageView extends StatefulWidget {
  const SchedulePageView({Key? key, required this.schedule}) : super(key: key);

  final Schedule schedule;

  @override
  State<StatefulWidget> createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  late ScrollController _nestedScrollViewController;
  late final PageController _controller;

  List<List<Lesson>> _getLessonsByWeek(int week, Schedule schedule) {
    List<List<Lesson>> lessonsInWeek = [];
    for (int i = 1; i <= 6; i++) {
      lessonsInWeek.add([]);
      for (var elements in schedule.schedule[i.toString()]!.lessons) {
        for (var lesson in elements) {
          if (lesson.weeks.contains(week)) lessonsInWeek[i - 1].add(lesson);
        }
      }
    }

    return lessonsInWeek;
  }

  Widget _buildEmptyLessons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/Saly-18.png'),
          height: 225.0,
        ),
        Text('Пар нет!', style: AppTextStyle.title),
      ],
    );
  }

  List<Lesson> _getLessonsWithEmpty(List<Lesson> lessons, String group) {
    List<Lesson> formattedLessons = [];
    if (ScheduleUtils.isCollegeGroup(group)) {
      ScheduleUtils.collegeTimesStart.forEach((key, value) {
        bool notEmpty = false;
        for (final lesson in lessons) {
          if (lesson.timeStart == key) {
            formattedLessons.add(lesson);
            notEmpty = true;
          }
        }
        if (notEmpty == false) {
          formattedLessons.add(
            Lesson(
              name: '',
              rooms: const [],
              timeStart: key,
              timeEnd: ScheduleUtils.collegeTimesEnd.keys.toList()[value - 1],
              weeks: const [],
              types: '',
              teachers: const [],
            ),
          );
        }
      });
    } else {
      ScheduleUtils.universityTimesStart.forEach((key, value) {
        bool notEmpty = false;
        for (final lesson in lessons) {
          if (lesson.timeStart == key) {
            formattedLessons.add(lesson);
            notEmpty = true;
          }
        }
        if (notEmpty == false) {
          formattedLessons.add(
            Lesson(
              name: '',
              rooms: const [],
              timeStart: key,
              timeEnd:
                  ScheduleUtils.universityTimesEnd.keys.toList()[value - 1],
              weeks: const [],
              types: '',
              teachers: const [],
            ),
          );
        }
      });
    }
    lessons = formattedLessons;
    return lessons;
  }

  Widget _buildPageViewContent(BuildContext context, int index, int week) {
    if (index == 6) {
      return _buildEmptyLessons();
    } else {
      var lessons = _getLessonsByWeek(week, widget.schedule)[index];

      if (lessons.isEmpty) return _buildEmptyLessons();

      final state = context.read<ScheduleBloc>().state as ScheduleLoaded;
      final ScheduleSettings settings = state.scheduleSettings;
      if (settings.showEmptyLessons) {
        lessons = _getLessonsWithEmpty(lessons, state.activeGroup);
      }

      return ListView.separated(
        itemCount: lessons.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: lessons[i].name.replaceAll(' ', '') != ''
                ? LessonCard(
                    name: lessons[i].name,
                    timeStart: lessons[i].timeStart,
                    timeEnd: lessons[i].timeEnd,
                    room: lessons[i].rooms.join(', '),
                    type: lessons[i].types,
                    teacher: lessons[i].teachers.join(', '),
                  )
                : EmptyLessonCard(
                    timeStart: lessons[i].timeStart,
                    timeEnd: lessons[i].timeEnd,
                  ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      );
    }
  }

  List<Story> _getActualStories(List<Story> stories) {
    List<Story> actualStories = [];
    for (final story in stories) {
      if (DateTime.now().compareTo(story.stopShowDate) == -1) {
        actualStories.add(story);
      }
    }

    return actualStories;
  }

  Widget _buildStories(List<Story> stories) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (_, int i) {
          if (DateTime.now().compareTo(stories[i].stopShowDate) == -1) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(
                        AppTheme.themeMode == ThemeMode.dark ? 0.1 : 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: StoryWidget(
                stories: stories,
                storyIndex: i,
              ),
            );
          }
          return Container();
        },
        separatorBuilder: (_, int i) => const SizedBox(width: 10),
        itemCount: stories.length,
      ),
    );
  }

  Widget _buildStoriesBuilder() {
    return BlocBuilder<StoriesBloc, StoriesState>(builder: (context, state) {
      if (state is StoriesInitial) {
        context.read<StoriesBloc>().add(LoadStories());
      } else if (state is StoriesLoaded) {
        final actualStories = _getActualStories(state.stories);
        if (actualStories.isNotEmpty) {
          return _buildStories(actualStories);
        }
      }
      return const SizedBox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isDesktop = constraints.maxWidth > tabletBreakpoint + 150;
        if (isDesktop) {
          return Row(
            children: [
              Expanded(flex: 2, child: _buildPageView()),
              Expanded(flex: 1, child: _buildCalendar(isDesktop)),
            ],
          );
        } else {
          return NestedScrollView(
            controller: _nestedScrollViewController,
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                pinned: false,
                title: const Text(
                  'Расписание',
                ),
                // stories
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: _buildStoriesBuilder(),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildCalendar(false),
              ),
            ],
            body: _buildPageView(),
          );
        }
      },
    );
  }
}
