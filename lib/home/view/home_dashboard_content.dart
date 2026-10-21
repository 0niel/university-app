import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_identity_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_metrics.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_quick_actions.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_status_strip.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_stories.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_top_row.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_trending.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/home/view/sheets/sheets.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/promo/promo.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_account_shortcut.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({
    required this.now,
    required this.selectedDay,
    required this.scrollController,
    required this.searchKey,
    required this.onSelectedDay,
    required this.onRetry,
    super.key,
  });
  final DateTime now;
  final DateTime selectedDay;
  final ScrollController scrollController;
  final GlobalKey searchKey;
  final ValueChanged<DateTime> onSelectedDay;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final config = context.read<UniversityConfig>();
    final persona = context.watch<AccountPersonaCubit?>()?.state;
    final isTeacher = persona?.isTeacher == true;
    final identityCubit = context.watch<HomeIdentityCubit?>();
    final identity = identityCubit?.state;
    final fullName = identity?.fullName?.trim();
    final handle = identity?.handle?.trim();
    final hasFullName = fullName != null && fullName.isNotEmpty;
    final hasHandle = handle != null && handle.isNotEmpty;
    final userName = hasFullName
        ? fullName
        : hasHandle
        ? '@$handle'
        : isTeacher
        ? l10n.teacherRoleFallback
        : l10n.homeStudent;
    final firstName = hasFullName
        ? (fullName.split(RegExp(r'\s+')).firstOrNull ?? fullName)
        : userName;
    final nameLoading = identityCubit != null && identity?.isLoaded != true;
    final state = context.watch<ScheduleBloc>().state;
    final schedule = state.selectedSchedule?.schedule ?? const <SchedulePart>[];
    final changesCubit = context.watch<ScheduleChangesCubit>();
    final target = homeScheduleTarget(state.selectedSchedule);
    final changes =
        target != null && changesCubit.matchesTarget(target.$1, target.$2)
        ? changesCubit.state.changes
        : const <ScheduleChange>[];
    final lessonsByDay = <DateTime, List<LessonSchedulePart>>{};
    List<LessonSchedulePart> lessonsForDay(DateTime day) =>
        lessonsByDay.putIfAbsent(
          DateUtils.dateOnly(day),
          () => homeLessonsForDay(schedule, day),
        );
    final days = homeWeekDays(selectedDay);
    final lessons = lessonsForDay(selectedDay);
    final entries = homeDayEntries(
      day: selectedDay,
      lessons: lessons,
      now: now,
      changes: changes,
    );
    final kind = homeHeroKind(
      entries: entries,
      isToday: DateUtils.isSameDay(selectedDay, now),
    );
    final loading =
        state.selectedSchedule == null &&
        (state.status == ScheduleStatus.initial ||
            state.status == ScheduleStatus.loading);
    final failed = state.status == ScheduleStatus.failure;
    final deadlines = context.watch<DeadlinesCubit>().state;
    final active = [...deadlines.activeDeadlines]
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final preferences = context.watch<UiPreferencesCubit>().state;
    final exam = homeNextExam(schedule, now);
    final tomorrow = DateUtils.dateOnly(now).add(const Duration(days: 1));
    final dayLabel = DateUtils.isSameDay(selectedDay, now)
        ? l10n.today
        : DateFormat.MMMEd(l10n.localeName).format(selectedDay);
    final top = math.max(
      AppSpacing.screenTop,
      MediaQuery.paddingOf(context).top + 12,
    );
    void open(HomeLessonEntry entry) => unawaited(
      ScheduleDetailsRoute(
        $extra: (entry.lesson, DateUtils.dateOnly(entry.start)),
      ).push(context),
    );
    void openDeadlines() => unawaited(
      const DeadlinesRoute().push<void>(context).then((_) {
        if (context.mounted) unawaited(context.read<DeadlinesCubit>().load());
      }),
    );
    var sectionOrder = 0;
    Widget inset(Widget child) => HomeSectionReveal(
      order: sectionOrder++,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: child,
      ),
    );
    return AppAmbientBackground(
      child: Stack(
        children: [
          ListView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: top,
              bottom: ninjaBottomInset(context) + AppSpacing.lg,
            ),
            children: [
              if (state.isOffline)
                inset(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: AppBanner(
                      message: l10n.homeOfflineBanner,
                      tone: AppBannerTone.warn,
                    ),
                  ),
                ),
              inset(
                HomeDashboardTopRow(
                  userName: userName,
                  now: now,
                  kind: kind,
                  searchKey: searchKey,
                  changes: changes,
                ),
              ),
              inset(
                HomeGreeting(
                  greeting: homeGreeting(l10n, now),
                  name: firstName,
                  nameLoading: nameLoading,
                  subtitle: loading
                      ? l10n.loadingContent
                      : state.selectedSchedule == null
                      ? l10n.noScheduleSelected
                      : '$dayLabel · ${homeStatusLabel(l10n, entries, kind)}',
                ),
              ),
              if (isTeacher)
                inset(
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.lg),
                    child: TeacherAccountShortcut(),
                  ),
                ),
              const PromoBannerSlot(
                placement: PromoPlacement.home,
                homeSlot: PromoHomeSlot.top,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  0,
                ),
              ),
              const HomeDashboardStories(),
              HomeWeekPills(
                days: days,
                selectedIndex: days.indexWhere(
                  (day) => DateUtils.isSameDay(day, selectedDay),
                ),
                today: now,
                onLessonCountForDay: (day) => lessonsForDay(day).length,
                onLessonColorsForDay: (day) => [
                  for (final lesson in lessonsForDay(day))
                    lessonAccentOf(context, lesson),
                ],
                lessonCounts: [
                  for (final day in days) lessonsForDay(day).length,
                ],
                lessonColors: [
                  for (final day in days)
                    [
                      for (final lesson in lessonsForDay(day))
                        lessonAccentOf(context, lesson),
                    ],
                ],
                changedDays: {
                  for (final (index, day) in days.indexed)
                    if (changes.any(
                      (change) => DateUtils.isSameDay(change.lessonDate, day),
                    ))
                      index,
                },
                onSelected: (index) {
                  if (index < 0) return;
                  final day = days.elementAtOrNull(index);
                  if (day != null) onSelectedDay(day);
                },
                onWeekChanged: (step) => onSelectedDay(
                  DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day + step * 7,
                  ),
                ),
              ),
              if (preferences.isSectionEnabled(HomeSection.today))
                inset(
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (failed)
                          AppBanner(
                            message: l10n.scheduleLoadingError,
                            tone: AppBannerTone.warn,
                            actionLabel: l10n.retry,
                            onAction: onRetry,
                          ),
                        if (loading)
                          AppSkeletonGroup(
                            semanticsLabel: l10n.loadingContent,
                            child: const AppSkeleton(
                              height: 220,
                              radius: AppRadius.hero,
                            ),
                          )
                        else if (state.selectedSchedule == null && !failed)
                          AppEmptyState(
                            title: l10n.noScheduleSelected,
                            lineIcon: AppLineIcon.calendar,
                            actionLabel: l10n.selectSchedule,
                            onAction: () => const ScheduleRoute().go(context),
                          )
                        else if (state.selectedSchedule != null) ...[
                          HomeHero(
                            entries: entries,
                            kind: kind,
                            tomorrow: lessonsForDay(tomorrow),
                            now: now,
                            deadline: active.firstOrNull,
                            onOpen: open,
                            onRoute:
                                config.isEnabled(UniversityCapability.campusMap)
                                ? (_) => const MapRoute().go(context)
                                : null,
                            onNote: (entry) =>
                                unawaited(showHomeNoteSheet(context, entry)),
                            onFreeRooms: () =>
                                const FreeRoomsRoute().go(context),
                            onDeadlines: openDeadlines,
                            onTomorrow: () => onSelectedDay(tomorrow),
                          ),
                          HomeLessonsGroup(
                            entries: entries,
                            featuredEntry: switch (kind) {
                              HomeHeroKind.done || HomeHeroKind.free => null,
                              HomeHeroKind.before ||
                              HomeHeroKind.during ||
                              HomeHeroKind.pause ||
                              HomeHeroKind.other => homeHeroEntry(
                                entries,
                                kind,
                              ),
                            },
                            onOpen: open,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: HomeDashboardStatusStrip(
                  deadlines: deadlines.deadlines,
                  now: now,
                  exam: isTeacher ? null : exam,
                  onProfile: () => const ProfileRoute().go(context),
                  onDeadlines: openDeadlines,
                  onExam: () => const ScheduleSessionRoute().go(context),
                ),
              ),
              PromoBannerSlot(
                placement: PromoPlacement.home,
                homeSlot: PromoHomeSlot.afterToday,
                now: now,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.sectionGap,
                  AppSpacing.screen,
                  0,
                ),
              ),
              if (preferences.isSectionEnabled(HomeSection.smartChips))
                inset(
                  const HomeDashboardQuickActions(),
                ),
              if (preferences.isSectionEnabled(HomeSection.deadlines))
                inset(
                  HomeDeadlinesGroup(
                    state: deadlines,
                    now: now,
                    onAdd: () => unawaited(
                      showAddDeadlineSheet(
                        context,
                        cubit: context.read(),
                      ),
                    ),
                    onOpen: openDeadlines,
                    onToggle: (deadline) =>
                        unawaited(_toggleDeadline(context, deadline)),
                    onRetry: () =>
                        unawaited(context.read<DeadlinesCubit>().load()),
                  ),
                ),
              if (preferences.isSectionEnabled(HomeSection.trending))
                inset(
                  const HomeDashboardTrending(),
                ),
              PromoBannerSlot(
                placement: PromoPlacement.home,
                homeSlot: PromoHomeSlot.bottom,
                now: now,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.section,
                  AppSpacing.screen,
                  0,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: BlocSelector<HomeCubit, HomeState, bool>(
              selector: (homeState) => homeState.searchCoachShown,
              builder: (context, shown) => shown
                  ? const SizedBox.shrink()
                  : SearchCoachOverlay(
                      anchorKey: searchKey,
                      onDismiss: () =>
                          context.read<HomeCubit>().dismissSearchCoach(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleDeadline(BuildContext context, Deadline deadline) async {
    final saved = await context.read<DeadlinesCubit>().toggleDone(deadline.id);
    if (!saved && context.mounted) {
      ToastManager.showError(
        context,
        message: context.l10n.deadlinesUpdateError,
      );
    }
  }
}
