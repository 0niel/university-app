import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/view/analytics/analytics_stats.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:share_launcher/share_launcher.dart';

part 'widgets/analytics_skeleton.dart';
part 'widgets/by_type_card.dart';
part 'widgets/day_bar.dart';
part 'widgets/insight_row.dart';
part 'widgets/load_by_day_card.dart';
part 'widgets/stat_card.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final schedule = context.select<ScheduleBloc, List<SchedulePart>>(
      (bloc) => bloc.state.selectedSchedule?.schedule ?? const [],
    );
    final status = context.select<ScheduleBloc, ScheduleStatus>(
      (bloc) => bloc.state.status,
    );
    final lessons = schedule.whereType<LessonSchedulePart>().toList();
    final stats = AnalyticsStats.fromLessons(lessons);

    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.analyticsTitle,
              onBack: () => Navigator.of(context).maybePop(),
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.share,
                  semanticsLabel: l10n.share,
                  onTap: lessons.isEmpty
                      ? null
                      : () => unawaited(
                          const ShareLauncher().share(
                            text: l10n.analyticsShareText(
                              stats.hoursPerWeek.toStringAsFixed(0),
                              stats.avgPerDay.toStringAsFixed(1),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: lessons.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        AppSpacing.sm,
                        AppSpacing.screen,
                        AppSpacing.xxl,
                      ),
                      child: Center(
                        child: AppStateSwitcher(
                          alignment: Alignment.center,
                          child: _buildDataless(context, l10n, status),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.sm,
                      AppSpacing.screen,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverList.list(
                      children: [
                        Wrap(
                          spacing: AppSpacing.gap,
                          runSpacing: AppSpacing.gap,
                          children: [
                            _StatCard(
                              value: stats.hoursPerWeek.toStringAsFixed(0),
                              label: l10n.analyticsHoursPerWeek,
                            ),
                            _StatCard(
                              value: stats.avgPerDay.toStringAsFixed(1),
                              label: l10n.analyticsAvgPerDay,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.gap),
                        _LoadByDayCard(stats: stats),
                        const SizedBox(height: AppSpacing.gap),
                        _ByTypeCard(stats: stats),
                        const SizedBox(height: AppSpacing.gap),
                        for (final insight in _insights(l10n, stats)) ...[
                          _InsightRow(insight: insight),
                          const SizedBox(height: AppSpacing.gap),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataless(
    BuildContext context,
    AppLocalizations l10n,
    ScheduleStatus status,
  ) {
    if (status == .loading) {
      return const _AnalyticsSkeleton(key: ValueKey('analytics_skeleton'));
    }
    if (status == .failure) {
      return AppErrorState(
        title: l10n.errorLoadingSchedule,
        message: l10n.lessonDetailsCheckConnection,
        primaryLabel: l10n.retry,
        footnote: null,
        onPrimary: () => context.read<ScheduleBloc>().add(
          const SelectedScheduleRefreshRequested(manual: true),
        ),
      ).animateEmptyState(key: const ValueKey('analytics_error'));
    }
    return AppEmptyState(
      title: l10n.noDataForAnalytics,
      subtitle: l10n.analyticsNoSchedule,
      icon: AppLineIconWidget(
        AppLineIcon.chart,
        size: 20,
        color: context.colors.muted,
      ),
    ).animateEmptyState(key: const ValueKey('analytics_empty'));
  }

  List<_Insight> _insights(
    AppLocalizations l10n,
    AnalyticsStats stats,
  ) {
    final dayNames = [
      l10n.weekdayMonday,
      l10n.weekdayTuesday,
      l10n.weekdayWednesday,
      l10n.weekdayThursday,
      l10n.weekdayFriday,
      l10n.weekdaySaturday,
      l10n.weekdaySunday,
    ];
    final entries = stats.hoursByWeekday.entries
        .where((entry) => entry.value > 0)
        .toList();
    if (entries.isEmpty) return const [];
    final lightest = entries.reduce((a, b) => a.value <= b.value ? a : b);

    return [
      _Insight(
        icon: AppLineIcon.calendar,
        title: l10n.analyticsInsightLightTitle(
          dayNames.elementAtOrNull(lightest.key - 1) ?? '',
        ),
        sub: l10n.analyticsInsightLightSub(lightest.value.toStringAsFixed(1)),
      ),
      if (stats.windowsPerWeek > 0)
        _Insight(
          icon: AppLineIcon.clock,
          title: l10n.analyticsInsightWindowsTitle(stats.windowsPerWeek),
          sub: l10n.analyticsInsightWindowsSub(
            stats.gapHoursPerWeek.toStringAsFixed(1),
          ),
        ),
    ];
  }
}

class _Insight {
  const _Insight({required this.icon, required this.title, required this.sub});

  final AppLineIcon icon;
  final String title;
  final String sub;
}
