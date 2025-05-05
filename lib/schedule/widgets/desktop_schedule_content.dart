import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:university_app_server_api/client.dart';

class DesktopScheduleContent extends StatelessWidget {
  const DesktopScheduleContent({
    super.key,
    required this.pageController,
    required this.showEmptyLessons,
    required this.showAnalytics,
    required this.schedule,
    required this.selectedDay,
  });

  final PageController pageController;
  final bool showEmptyLessons;
  final bool showAnalytics;
  final List<SchedulePart> schedule;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Use CustomScrollView to allow expanded content when analytics is disabled
    return Container(
      color: colors.background02.withOpacity(0.2),
      child: CustomScrollView(
        slivers: [
          // Lessons header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.colorful01.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: HugeIcon(icon: HugeIcons.strokeRoundedNotebook, color: colors.colorful01, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Dynamic day text based on selected day
                        'Занятия на ${_formatDayText(selectedDay)}',
                        style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Расписание занятий на выбранный день',
                        style: AppTextStyle.captionL.copyWith(color: colors.deactive),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: showAnalytics ? 400 : MediaQuery.of(context).size.height - 100,
                child: _EventsPageView(pageController: pageController, showEmptyLessons: showEmptyLessons),
              ),
            ),
          ),

          // Analytics section
          if (showAnalytics)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: colors.background03.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: ScheduleAnalytics(schedule: schedule, selectedDay: selectedDay),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDayText(DateTime day) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      return 'сегодня';
    } else if (day.year == tomorrow.year && day.month == tomorrow.month && day.day == tomorrow.day) {
      return 'завтра';
    } else {
      return DateFormat('d MMMM', 'ru_RU').format(day);
    }
  }

  Widget _buildDisplayOptions(BuildContext context) {
    final bloc = context.read<ScheduleBloc>();
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: colors.background03.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          // Empty lessons toggle
          Tooltip(
            message: 'Показывать пустые пары',
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                bloc.add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: !showEmptyLessons));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: showEmptyLessons ? colors.primary.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      showEmptyLessons ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                      color: showEmptyLessons ? colors.primary : colors.deactive,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Пустые пары',
                      style: AppTextStyle.captionL.copyWith(
                        color: showEmptyLessons ? colors.primary : colors.deactive,
                        fontWeight: showEmptyLessons ? FontWeight.w500 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Analytics toggle button
          const SizedBox(width: 8),
          Tooltip(
            message: 'Аналитика расписания',
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                bloc.add(SetAnalyticsVisibility(showAnalytics: !showAnalytics));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: showAnalytics ? colors.colorful04.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedChart,
                      size: 16,
                      color: showAnalytics ? colors.colorful04 : colors.deactive,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Аналитика',
                      style: AppTextStyle.captionL.copyWith(
                        color: showAnalytics ? colors.colorful04 : colors.deactive,
                        fontWeight: showAnalytics ? FontWeight.w500 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsPageView extends StatelessWidget {
  const _EventsPageView({required this.pageController, required this.showEmptyLessons});

  final PageController pageController;
  final bool showEmptyLessons;

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

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

        if (allLessons.isEmpty) {
          return _buildEmptyDayMessage(context);
        }

        final numberedLessons = allLessons.where((l) => l.lessonBells.number != null).toList();
        final unnumberedLessons = allLessons.where((l) => l.lessonBells.number == null).toList();

        numberedLessons.sort(
          (a, b) => _toMinutes(a.lessonBells.startTime).compareTo(_toMinutes(b.lessonBells.startTime)),
        );
        unnumberedLessons.sort(
          (a, b) => _toMinutes(a.lessonBells.startTime).compareTo(_toMinutes(b.lessonBells.startTime)),
        );

        final lessonsByTime = <int, List<LessonSchedulePart>>{};

        // Group lessons by their number
        for (final l in numberedLessons) {
          final key = l.lessonBells.number!;
          lessonsByTime.putIfAbsent(key, () => []).add(l);
        }

        // Handle unnumbered lessons
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

        return _buildLessonsList(context, lessonsByTime, day, showEmptyLessons);
      },
    );
  }

  Widget _buildEmptyDayMessage(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: colors.background03.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: HugeIcon(icon: HugeIcons.strokeRoundedCoffee01, size: 36, color: colors.deactive)),
          ),
          const SizedBox(height: 20),
          Text(
            'Нет занятий в этот день',
            style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: colors.active),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 300,
            child: Text(
              'Можно отдохнуть или заняться самостоятельной работой',
              style: AppTextStyle.body.copyWith(color: colors.deactive),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            context,
            text: 'Перейти к другому дню',
            icon: HugeIcons.strokeRoundedCalendar01,
            color: colors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color color,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ElevatedButton.icon(
      onPressed: () {
        // Найти следующий день с занятиями можно было бы, но это потребует дополнительного анализа
        final todayIndex = Calendar.getPageIndex(Calendar.getNowWithoutTime());
        pageController.animateToPage(todayIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
      ),
      icon: HugeIcon(icon: icon, size: 18, color: color),
      label: Text(text, style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildLessonsList(
    BuildContext context,
    Map<int, List<LessonSchedulePart>> lessonsByTime,
    DateTime day,
    bool showEmptyLessons,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (showEmptyLessons) {
      final List<Widget> widgets = [];
      final scheduledKeys = lessonsByTime.keys.where((k) => k != 0).toList()..sort();

      for (var lessonNumber = 1; lessonNumber <= 7; lessonNumber++) {
        final lessons = lessonsByTime[lessonNumber] ?? [];

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson number indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: lessons.isNotEmpty ? colors.primary.withOpacity(0.1) : colors.background03.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$lessonNumber',
                      style: AppTextStyle.bodyL.copyWith(
                        color: lessons.isNotEmpty ? colors.primary : colors.deactive,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Lesson content
                Expanded(
                  child:
                      lessons.isNotEmpty
                          ? _buildLessonCard(context, lessons, day)
                          : _buildEmptyLesson(context, lessonNumber),
                ),
              ],
            ),
          ),
        );
      }

      return ListView(physics: const BouncingScrollPhysics(), children: widgets);
    } else {
      final sortedKeys = lessonsByTime.keys.where((k) => k != 0).toList()..sort();
      final List<Widget> widgets = [];

      for (var i = 0; i < sortedKeys.length; i++) {
        final key = sortedKeys[i];
        final lessons = lessonsByTime[key]!;

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson number indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '$key',
                      style: AppTextStyle.bodyL.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Lesson content
                Expanded(child: _buildLessonCard(context, lessons, day)),
              ],
            ),
          ),
        );

        // Add window break indicator if needed
        if (i < sortedKeys.length - 1) {
          final int currentKey = sortedKeys[i];
          final int nextKey = sortedKeys[i + 1];
          if (nextKey - currentKey > 1) {
            final windowCount = nextKey - currentKey - 1;
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
                child: Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedHourglass, size: 16, color: colors.deactive),
                    const SizedBox(width: 8),
                    Text(
                      'Окно: $windowCount ${_pluralizeLesson(windowCount)}',
                      style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }

      return ListView(physics: const BouncingScrollPhysics(), children: widgets);
    }
  }

  String _pluralizeLesson(int count) {
    if (count == 1) return 'пара';
    if (count >= 2 && count <= 4) return 'пары';
    return 'пар';
  }

  Widget _buildEmptyLesson(BuildContext context, int lessonNumber) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colors.background03.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.background03.withOpacity(0.5), width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(HugeIcons.strokeRoundedBorderNone01, size: 18, color: colors.deactive),
          const SizedBox(width: 8),
          Text('Нет занятия', style: AppTextStyle.body.copyWith(color: colors.deactive, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, List<LessonSchedulePart> lessons, DateTime day) {
    if (lessons.length == 1) {
      final lesson = lessons.first;
      return LessonCard(
        lesson: lesson,
        onTap: (lesson) {
          context.go('/schedule/details', extra: (lesson, day));
        },
      );
    }

    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final currentLesson = lessons[index];
          return LessonCard(
            countInGroup: lessons.length,
            indexInGroup: index,
            lesson: currentLesson,
            onTap: (lesson) {
              context.go('/schedule/details', extra: (lesson, day));
            },
          );
        },
      ),
    );
  }
}
