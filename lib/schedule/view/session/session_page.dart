import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_section_header.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'widgets/countdown_hero.dart';
part 'widgets/exam_card.dart';
part 'widgets/hero_stat.dart';
part 'widgets/session_skeleton.dart';
part 'widgets/study_plan_banner.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  static const Set<LessonType> _examTypes = {
    LessonType.exam,
    LessonType.credit,
    LessonType.consultation,
  };

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(context.read<ExamReadinessCubit>().load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final schedule = context.select<ScheduleBloc, List<SchedulePart>>(
      (bloc) => bloc.state.selectedSchedule?.schedule ?? const [],
    );
    final scheduleLoading = context.select<ScheduleBloc, bool>(
      (bloc) => bloc.state.status == .loading,
    );
    final readiness = context.watch<ExamReadinessCubit>().state;
    final exams = _buildExams(context, l10n, schedule, readiness);
    final loading = scheduleLoading && exams.isEmpty;
    final failed = readiness.status == .failure;

    final colors = context.ninja;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.sessionTitle,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                NinjaMetrics.screenPadding,
                8,
                NinjaMetrics.screenPadding,
                32,
              ),
              sliver: SliverList.list(
                children: [
                  if (failed) ...[
                    NinjaErrorCard(
                      title: l10n.loadingError,
                      message: l10n.tryAgain,
                      actionLabel: l10n.retry,
                      onAction: () =>
                          unawaited(context.read<ExamReadinessCubit>().load()),
                    ),
                    const SizedBox(height: 10),
                  ],
                  NinjaStateSwitcher(
                    child: loading
                        ? const _SessionSkeleton(
                            key: ValueKey('session_skeleton'),
                          )
                        : Column(
                            key: const ValueKey('session_content'),
                            crossAxisAlignment: .stretch,
                            children: [
                              _CountdownHero(exams: exams),
                              if (exams.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                _StudyPlanBanner(exams: exams),
                              ],
                              const SizedBox(height: 28),
                              if (exams.isNotEmpty) ...[
                                NinjaScheduleSectionHeader(
                                  title: l10n.sessionScheduleTitle,
                                ),
                                const SizedBox(height: 10),
                              ],
                              for (final (index, exam) in exams.indexed) ...[
                                _ExamCard(
                                  exam: exam,
                                  onTap: () =>
                                      _openReadinessSheet(context, exam),
                                ).animateListItem(index: index),
                                const SizedBox(height: 10),
                              ],
                              if (exams.isEmpty)
                                Padding(
                                  padding: const .only(top: 12),
                                  child: NinjaEmptyState(
                                    title: l10n.sessionNoExamsTitle,
                                    message: l10n.sessionNoExams,
                                    icon: AppLineIconWidget(
                                      AppLineIcon.check,
                                      size: 20,
                                      color: colors.muted,
                                    ),
                                  ).animateEmptyState(),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_Exam> _buildExams(
    BuildContext context,
    AppLocalizations l10n,
    List<SchedulePart> schedule,
    ExamReadinessState readiness,
  ) {
    final today = DateTime.now();
    final midnight = DateTime(today.year, today.month, today.day);
    final exams = <_Exam>[];
    for (final part in schedule.whereType<LessonSchedulePart>()) {
      if (!SessionPage._examTypes.contains(part.lessonType)) continue;
      for (final date in part.dates) {
        if (date.isBefore(midnight)) continue;
        exams.add(
          _Exam(
            subject: part.subject,
            lessonType: part.lessonType,
            typeName: LessonCard.getLessonTypeName(l10n, part.lessonType),
            color: LessonCard.getColorByTypeFor(
              context,
              part.lessonType,
            ),
            date: date,
            time: '${part.lessonBells.startTime}',
            room: part.classrooms.firstOrNull?.name ?? '—',
            teacher: part.teachers.firstOrNull?.name ?? '',
            days: date.difference(midnight).inDays,
            readiness: readiness.readinessFor(part.subject),
          ),
        );
      }
    }
    exams.sort((a, b) => a.date.compareTo(b.date));
    return exams;
  }

  void _openReadinessSheet(BuildContext context, _Exam exam) {
    var value = (exam.readiness * 100).round();
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.sessionReadiness,
        subtitle: exam.subject,
        child: StatefulBuilder(
          builder: (context, setState) {
            final colors = context.ninja;
            return Padding(
              padding: const .only(top: 4, bottom: 8),
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    '$value%',
                    style: NinjaText.tabular(
                      NinjaText.display.copyWith(color: colors.ink),
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      activeTrackColor: colors.brand,
                      inactiveTrackColor: colors.surfaceAlt,
                      thumbColor: colors.brand,
                      overlayColor: colors.brand.withValues(alpha: 0.12),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      trackShape: const RoundedRectSliderTrackShape(),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 11,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 22,
                      ),
                      showValueIndicator: .never,
                    ),
                    child: SizedBox(
                      height: NinjaMetrics.minTouchTarget,
                      child: Slider(
                        value: value.toDouble(),
                        max: 100,
                        divisions: 20,
                        onChanged: (next) =>
                            setState(() => value = next.round()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  NinjaButton.primary(
                    label: context.l10n.save,
                    expanded: true,
                    size: .large,
                    onPressed: () {
                      unawaited(
                        context.read<ExamReadinessCubit>().setReadiness(
                          exam.subject,
                          value,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Exam {
  const _Exam({
    required this.subject,
    required this.lessonType,
    required this.typeName,
    required this.color,
    required this.date,
    required this.time,
    required this.room,
    required this.teacher,
    required this.days,
    required this.readiness,
  });

  final String subject;
  final LessonType lessonType;
  final String typeName;
  final Color color;
  final DateTime date;
  final String time;
  final String room;
  final String teacher;
  final int days;
  final double readiness;
}
