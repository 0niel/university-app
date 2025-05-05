import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:university_app_server_api/client.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';

class ScheduleAnalytics extends StatefulWidget {
  const ScheduleAnalytics({super.key, required this.schedule, required this.selectedDay});

  final List<SchedulePart> schedule;
  final DateTime selectedDay;

  @override
  State<ScheduleAnalytics> createState() => _ScheduleAnalyticsState();
}

class _ScheduleAnalyticsState extends State<ScheduleAnalytics> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final lessonParts = widget.schedule.whereType<LessonSchedulePart>().toList();

    if (lessonParts.isEmpty) {
      return _buildEmptyAnalytics(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(HugeIcons.strokeRoundedChartBarLine, size: 24, color: colors.colorful04),
            const SizedBox(width: 12),
            Text(
              'Аналитика расписания',
              style: AppTextStyle.title.copyWith(fontWeight: FontWeight.bold, color: colors.active),
            ),
            const Spacer(),
            _buildExportButton(context),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Статистика и анализ вашего учебного расписания',
          style: AppTextStyle.body.copyWith(color: colors.deactive),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: colors.background03.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: colors.deactive,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(10)),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle: AppTextStyle.body,
            padding: const EdgeInsets.all(4),
            tabs: [
              Tab(
                height: 36,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedChartColumn, size: 16),
                    const SizedBox(width: 6),
                    const Text('Загрузка по дням'),
                  ],
                ),
              ),
              Tab(
                height: 36,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedChartAverage, size: 16),
                    const SizedBox(width: 6),
                    const Text('Типы занятий'),
                  ],
                ),
              ),
              Tab(
                height: 36,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedTeacher, size: 16),
                    const SizedBox(width: 6),
                    const Text('Преподаватели'),
                  ],
                ),
              ),
              Tab(
                height: 36,
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedUniversity, size: 16),
                    const SizedBox(width: 6),
                    const Text('Аудитории'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey<int>(_selectedTab),
            child:
                _selectedTab == 0
                    ? _buildWeeklyLoadChart(lessonParts, colors)
                    : _selectedTab == 1
                    ? _buildLessonTypeDistribution(lessonParts, colors)
                    : _selectedTab == 2
                    ? _buildTeacherDistribution(lessonParts, colors)
                    : _buildClassroomDistribution(lessonParts, colors),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyAnalytics(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: colors.background03.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: Icon(HugeIcons.strokeRoundedChart, size: 36, color: colors.deactive)),
          ),
          const SizedBox(height: 20),
          Text(
            'Нет данных для аналитики',
            style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: colors.active),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 300,
            child: Text(
              'Выберите другое расписание или проверьте наличие занятий',
              style: AppTextStyle.body.copyWith(color: colors.deactive),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Tooltip(
      message: 'Экспорт данных',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder:
                  (context) => Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Экспорт данных',
                          style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.bold, color: colors.active),
                        ),
                        const SizedBox(height: 24),
                        _buildExportOption(
                          context,
                          title: 'PDF документ',
                          subtitle: 'Полный отчет со всеми графиками',
                          icon: HugeIcons.strokeRoundedDocumentAttachment,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 12),
                        _buildExportOption(
                          context,
                          title: 'Excel таблица',
                          subtitle: 'Данные в табличном формате',
                          icon: HugeIcons.strokeRoundedTable,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 12),
                        _buildExportOption(
                          context,
                          title: 'Поделиться изображением',
                          subtitle: 'Текущим графиком или всеми',
                          icon: HugeIcons.strokeRoundedShare01,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.background03.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(HugeIcons.strokeRoundedDownload01, size: 16, color: colors.deactive),
                const SizedBox(width: 6),
                Text(
                  'Экспорт',
                  style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: colors.background03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.background03.withOpacity(0.3), shape: BoxShape.circle),
                child: Center(child: Icon(icon, size: 20, color: colors.active)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.deactive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyLoadChart(List<LessonSchedulePart> lessons, AppColors colors) {
    final Map<int, int> lessonsByDay = {};
    for (var lesson in lessons) {
      final uniqueWeekdays = lesson.dates.map((d) => d.weekday).toSet();
      for (var weekday in uniqueWeekdays) {
        lessonsByDay[weekday] = (lessonsByDay[weekday] ?? 0) + 1;
      }
    }

    // Use fixed denominator for the full week (7 days)
    final int daysCount = 7;

    final int totalLessons = lessonsByDay.values.fold(0, (sum, count) => sum + count);

    final weekdayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final barGroups = List.generate(7, (index) {
      final day = index + 1; // 1-indexed (Monday is 1)
      final value = lessonsByDay[day] ?? 0;
      final isWeekend = (day == DateTime.sunday);
      final isHighlighted = day == widget.selectedDay.weekday;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            color:
                isHighlighted
                    ? colors.primary
                    : isWeekend
                    ? colors.colorful04.withOpacity(0.7)
                    : colors.colorful01.withOpacity(0.7),
            width: 20,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          ),
        ],
      );
    });

    final Map<int, String> weekdayFullNames = {
      1: 'Понедельник',
      2: 'Вторник',
      3: 'Среда',
      4: 'Четверг',
      5: 'Пятница',
      6: 'Суббота',
      7: 'Воскресенье',
    };

    // Improved way to find the day with the most lessons:
    // If multiple days have the same number of lessons, pick the later day in the week
    int maxDay;
    if (lessonsByDay.isNotEmpty) {
      final maxLessons = lessonsByDay.values.reduce((a, b) => a > b ? a : b);
      maxDay = lessonsByDay.entries
          .where((entry) => entry.value == maxLessons)
          .map((entry) => entry.key)
          .reduce((a, b) => a > b ? a : b); // Pick the later day in the week
    } else {
      maxDay = widget.selectedDay.weekday;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Распределение пар по дням недели',
          style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RichText(
            text: TextSpan(
              style: AppTextStyle.captionL.copyWith(color: colors.deactive),
              children: [
                const TextSpan(text: 'День с наибольшей нагрузкой: '),
                TextSpan(
                  text: weekdayFullNames[maxDay],
                  style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          weekdayNames[value.toInt()],
                          style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Using a more responsive layout with LayoutBuilder
        LayoutBuilder(
          builder: (context, constraints) {
            // Determine number of columns based on available width
            final isWideScreen = constraints.maxWidth > 700;
            final crossAxisCount = isWideScreen ? 4 : 2;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: isWideScreen ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  child: _buildEnhancedStatCard(
                    context,
                    title: 'Общее количество пар',
                    value: '${lessons.length}',
                    icon: HugeIcons.strokeRoundedClock01,
                    color: colors.colorful01,
                    subtitle: 'За весь период',
                  ),
                ),
                SizedBox(
                  width: isWideScreen ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  child: _buildEnhancedStatCard(
                    context,
                    title: 'Среднее в день',
                    value: (totalLessons / daysCount).toStringAsFixed(1),
                    icon: HugeIcons.strokeRoundedChart,
                    color: colors.colorful02,
                    subtitle: 'Учебная нагрузка',
                  ),
                ),
                SizedBox(
                  width: isWideScreen ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  child: _buildEnhancedStatCard(
                    context,
                    title: 'Максимум в день',
                    value: '${lessonsByDay.values.maxOrNull ?? 0}',
                    icon: HugeIcons.strokeRoundedChartBubble01,
                    color: colors.colorful03,
                    subtitle: 'Самый загруженный день',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLessonTypeDistribution(List<LessonSchedulePart> lessons, AppColors colors) {
    // Count lessons by type
    final Map<LessonType, int> countByType = {};
    for (var lesson in lessons) {
      countByType[lesson.lessonType] = (countByType[lesson.lessonType] ?? 0) + 1;
    }

    // Prepare data for pie chart
    final List<PieChartSectionData> sections = [];
    countByType.forEach((type, count) {
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '${(count / lessons.length * 100).round()}%',
          radius: 100,
          color: LessonCard.getColorByType(type),
          titleStyle: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          badgeWidget: sections.length < 3 ? null : const Text(''),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Распределение занятий по типам',
          style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(height: 250, child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 40))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...countByType.entries.map((entry) {
                      return _buildLegendItem(
                        context,
                        title: LessonCard.getLessonTypeName(entry.key),
                        count: entry.value,
                        percent: entry.value / lessons.length * 100,
                        color: LessonCard.getColorByType(entry.key),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeacherDistribution(List<LessonSchedulePart> lessons, AppColors colors) {
    // Count lessons by teacher
    final Map<String, int> countByTeacher = {};
    for (var lesson in lessons) {
      for (var teacher in lesson.teachers) {
        countByTeacher[teacher.name] = (countByTeacher[teacher.name] ?? 0) + 1;
      }
    }

    // Sort by count
    final sortedTeachers = countByTeacher.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Take top 10
    final topTeachers = sortedTeachers.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Распределение занятий по преподавателям',
          style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...topTeachers.map((entry) {
          return _buildTeacherRow(
            context,
            name: entry.key,
            count: entry.value,
            percent: entry.value / lessons.length * 100,
            color: colors.colorful03,
          );
        }),
      ],
    );
  }

  Widget _buildClassroomDistribution(List<LessonSchedulePart> lessons, AppColors colors) {
    // Count lessons by classroom
    final Map<String, int> countByClassroom = {};
    for (var lesson in lessons) {
      for (var classroom in lesson.classrooms) {
        final key = classroom.name + (classroom.campus != null ? ' (${classroom.campus?.shortName ?? ""})' : '');
        countByClassroom[key] = (countByClassroom[key] ?? 0) + 1;
      }
    }

    // Sort by count
    final sortedClassrooms = countByClassroom.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Take top 10
    final topClassrooms = sortedClassrooms.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Распределение занятий по аудиториям',
          style: AppTextStyle.titleS.copyWith(color: colors.active, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...topClassrooms.map((entry) {
          return _buildTeacherRow(
            context,
            name: entry.key,
            count: entry.value,
            percent: entry.value / lessons.length * 100,
            icon: HugeIcons.strokeRoundedBuilding04,
            color: colors.colorful02,
          );
        }),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required String title,
    required int count,
    required double percent,
    required Color color,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500)),
                Text('$count (${percent.round()}%)', style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherRow(
    BuildContext context, {
    required String name,
    required int count,
    required double percent,
    IconData icon = HugeIcons.strokeRoundedTeacher,
    required Color color,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Icon(icon, size: 18, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(name, style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: colors.background03,
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count (${percent.round()}%)',
            style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.background03.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: colors.background03.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Text(
                  subtitle ?? '',
                  style: AppTextStyle.captionS.copyWith(color: color, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: AppTextStyle.title.copyWith(fontWeight: FontWeight.bold, color: colors.active)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
        ],
      ),
    );
  }
}
