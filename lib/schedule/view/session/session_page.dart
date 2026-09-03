import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/exam_readiness/exam_readiness_cubit.dart';
import 'package:rtu_mirea_app/schedule/view/session/exam_topics_cubit.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_exam.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/countdown_hero.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/exam_card.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/exam_topics.dart';
import 'package:rtu_mirea_app/tools/view/widgets/tools_number_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ExamTopicsCubit(),
    child: const _SessionView(),
  );
}

class _SessionView extends StatefulWidget {
  const _SessionView();

  @override
  State<_SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<_SessionView> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<ExamReadinessCubit>().load());
  }

  void _sync(SessionExam exam) {
    final value = context.read<ExamTopicsCubit>().state.readiness(exam.key);
    if (value != null &&
        context.read<ScheduleRepository>().hasAuthenticatedUser) {
      unawaited(
        context.read<ExamReadinessCubit>().setReadiness(
          exam.subject,
          (value * 100).round(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final schedule = context.watch<ScheduleBloc>().state;
    final readiness = context.watch<ExamReadinessCubit>().state;
    final topics = context.watch<ExamTopicsCubit>();
    final exams = SessionExam.fromSchedule(
      context,
      schedule.selectedSchedule?.schedule ?? const [],
    );
    final selected =
        exams.firstWhereOrNull((exam) => exam.key == _selected) ??
        exams.firstOrNull;
    double ready(SessionExam exam) =>
        topics.state.readiness(exam.key) ??
        readiness.readinessFor(exam.subject);
    final loading = schedule.status == ScheduleStatus.loading && exams.isEmpty;
    return ColoredBox(
      color: context.colors.canvas,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.examsTitle,
              onBack: () => Navigator.of(context).maybePop(),
              backSemanticsLabel: l10n.back,
              trailingLabel: exams.isEmpty
                  ? null
                  : l10n.examsSessionIn(exams.first.days),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentGap,
              AppSpacing.screen,
              AppSpacing.xxlg,
            ),
            sliver: SliverList.list(
              children: [
                if (schedule.status == ScheduleStatus.failure) ...[
                  AppErrorState(
                    title: l10n.loadingError,
                    message: l10n.tryAgain,
                    primaryLabel: l10n.retry,
                    footnote: null,
                    onPrimary: () => context.read<ScheduleBloc>().add(
                      const SelectedScheduleRefreshRequested(manual: true),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (readiness.status == ExamReadinessStatus.failure) ...[
                  AppErrorState(
                    title: l10n.loadingError,
                    message: l10n.tryAgain,
                    primaryLabel: l10n.retry,
                    footnote: null,
                    onPrimary: () =>
                        unawaited(context.read<ExamReadinessCubit>().load()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (loading)
                  const AppSkeletonGroup(
                    child: AppListGroup(
                      children: [
                        AppSkeletonRow(),
                        AppSkeletonRow(),
                        AppSkeletonRow(),
                      ],
                    ),
                  )
                else if (selected == null) ...[
                  if (schedule.status != ScheduleStatus.failure)
                    AppEmptyState(
                      title: l10n.sessionNoExamsTitle,
                      subtitle: l10n.sessionNoExams,
                      lineIcon: AppLineIcon.check,
                    ),
                ] else ...[
                  CountdownHero(
                    exam: selected,
                    readiness: ready(selected),
                    onReadiness:
                        topics.state.forExam(selected.key).isEmpty &&
                            context
                                .read<ScheduleRepository>()
                                .hasAuthenticatedUser
                        ? () => showToolsNumberSheet(
                            context,
                            title: l10n.examsReadiness,
                            value: (ready(selected) * 100).round(),
                            max: 100,
                            onSave: (value) => unawaited(
                              context.read<ExamReadinessCubit>().setReadiness(
                                selected.subject,
                                value,
                              ),
                            ),
                          )
                        : null,
                  ),
                  ExamTopics(
                    exam: selected,
                    cubit: topics,
                    onChanged: () => _sync(selected),
                  ),
                  AppOverline(
                    l10n.examsAllTitle,
                    topPadding: AppSpacing.xlg,
                    bottomPadding: AppSpacing.md,
                  ),
                  for (final exam in exams) ...[
                    ExamCard(
                      exam: exam,
                      readiness: ready(exam),
                      onTap: () => setState(() => _selected = exam.key),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
