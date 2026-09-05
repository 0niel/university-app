import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_gamification_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_identity_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_stories_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_metrics.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/home/view/sheets/sheets.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/notifications/notifications.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/promo/promo.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:rtu_mirea_app/top_discussions/view/discourse_topic_utils.dart';
import 'package:schedule_repository/schedule_repository.dart';

void _openTopic(BuildContext context, DiscourseTopic topic) {
  final forumUrl = context.read<UniversityConfig>().communityForumUrl;
  unawaited(openDiscourseTopic(forumUrl, topic.id));
}

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
    final colors = context.colors;
    final config = context.read<UniversityConfig>();
    final user = context.watch<AppBloc>().state.user;
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
        : l10n.homeStudent;
    final firstName = hasFullName
        ? fullName.split(RegExp(r'\s+')).first
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
    final days = homeWeekDays(selectedDay);
    final lessons = homeLessonsForDay(schedule, selectedDay);
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
    final profile = context.watch<HomeGamificationCubit>().state;
    final categoriesState = context.watch<CategoriesBloc>().state;
    final sources = categoriesState.sources;
    final sourcesLoading =
        categoriesState.status == CategoriesStatus.initial ||
        categoriesState.status == CategoriesStatus.loading;
    final preferences = context.watch<UiPreferencesCubit>().state;
    final favorites = context.watch<FavoriteServicesCubit>().state;
    final catalogState = context.watch<ServiceCatalogCubit>().state;
    final catalog = catalogState.catalog;
    final quickActionsLoading = !favorites.loaded || catalogState.isLoading;
    final seen = <String>{};
    final services = [
      for (final section in ServicesDirectory.sections(
        context,
        config: config,
        catalog: catalog,
      ))
        for (final entry in section.entries)
          if (favorites.contains(entry.model) && seen.add(entry.id)) entry,
    ];
    final notificationState = context.watch<NotificationsCubit>().state;
    final notifications = buildNotificationFeed(
      l10n: l10n,
      pushes: notificationState.pushes,
      changes: changes,
      now: now,
    );
    final exam = homeNextExam(schedule, now);
    final examState = context.watch<ExamReadinessCubit>().state;
    final readiness =
        exam != null &&
            examState.entries.any(
              (entry) => entry.subjectName == exam.lesson.subject,
            )
        ? examState.readinessFor(exam.lesson.subject)
        : null;
    final tomorrow = DateUtils.dateOnly(now).add(const Duration(days: 1));
    final dayLabel = DateUtils.isSameDay(selectedDay, now)
        ? l10n.today
        : DateFormat.MMMEd(l10n.localeName).format(selectedDay);
    final top = math.max(
      AppSpacing.screenTop,
      MediaQuery.paddingOf(context).top + 12,
    );
    final showCoach = !context.watch<HomeCubit>().state.searchCoachShown;
    void open(HomeLessonEntry entry) => unawaited(
      ScheduleDetailsRoute(
        $extra: (entry.lesson, DateUtils.dateOnly(entry.start)),
      ).push<void>(context),
    );
    void openDeadlines() => unawaited(
      const DeadlinesRoute().push<void>(context).then((_) {
        if (context.mounted) unawaited(context.read<DeadlinesCubit>().load());
      }),
    );
    Widget inset(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: child,
    );
    return Stack(
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
              HomeTopRow(
                userName: userName,
                photoUrl: user.photo,
                level: profile?.isEmpty == false ? profile?.level : null,
                now: now,
                dotColor: kind == HomeHeroKind.during
                    ? colors.accent
                    : kind == HomeHeroKind.pause
                    ? colors.lecture
                    : colors.muted2,
                searchKey: searchKey,
                unreadCount: notificationState.unreadCount(
                  notifications.map((item) => item.id),
                ),
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
            HomeStoriesRail(
              sources: sources,
              seenSourceIds: context.watch<HomeStoriesCubit>().state,
              onSourceOpened: context.read<HomeStoriesCubit>().markSeen,
              loading: sourcesLoading,
            ),
            inset(
              HomeWeekPills(
                days: days,
                selectedIndex: days.indexWhere(
                  (day) => DateUtils.isSameDay(day, selectedDay),
                ),
                today: now,
                lessonCountForDay: (day) =>
                    homeLessonsForDay(schedule, day).length,
                lessonColorsForDay: (day) => [
                  for (final lesson in homeLessonsForDay(schedule, day))
                    lessonAccentOf(context, lesson),
                ],
                lessonCounts: [
                  for (final day in days)
                    homeLessonsForDay(schedule, day).length,
                ],
                lessonColors: [
                  for (final day in days)
                    [
                      for (final lesson in homeLessonsForDay(schedule, day))
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
                onSelected: (index) => onSelectedDay(days[index]),
                onWeekChanged: (step) => onSelectedDay(
                  DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day + step * 7,
                  ),
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
                          tomorrow: homeLessonsForDay(schedule, tomorrow),
                          now: now,
                          deadline: active.firstOrNull,
                          onOpen: open,
                          onRoute:
                              config.isEnabled(UniversityCapability.campusMap)
                              ? (_) => const MapRoute().go(context)
                              : null,
                          onNote: (entry) =>
                              unawaited(showHomeNoteSheet(context, entry)),
                          onFreeRooms: () => const FreeRoomsRoute().go(context),
                          onDeadlines: openDeadlines,
                          onTomorrow: () => onSelectedDay(tomorrow),
                        ),
                        HomeLessonsGroup(
                          entries: entries,
                          featuredEntry:
                              kind == HomeHeroKind.done ||
                                  kind == HomeHeroKind.free
                              ? null
                              : homeHeroEntry(entries, kind),
                          onOpen: open,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: HomeStatusStrip(
                deadlines: deadlines.deadlines,
                profile: profile,
                now: now,
                exam: exam,
                readiness: readiness,
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
                HomeQuickActions(
                  services: services,
                  onAll: () => const ServicesRoute().go(context),
                  loading: quickActionsLoading,
                ),
              ),
            if (preferences.isSectionEnabled(HomeSection.deadlines))
              inset(
                HomeDeadlinesGroup(
                  state: deadlines,
                  now: now,
                  onAdd: () => unawaited(
                    showAddDeadlineSheet(
                      context,
                      cubit: context.read<DeadlinesCubit>(),
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
                HomeTrendingGroup(
                  state: context.watch<DiscourseBloc>().state,
                  onAll: () => const CommunitiesRoute().go(context),
                  onOpen: (topic) => _openTopic(context, topic),
                  onRetry: () => context.read<DiscourseBloc>().add(
                    const DiscourseTopTopicsRequested(),
                  ),
                ),
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
        if (showCoach)
          Positioned.fill(
            child: SearchCoachOverlay(
              anchorKey: searchKey,
              onDismiss: () => context.read<HomeCubit>().dismissSearchCoach(),
            ),
          ),
      ],
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
