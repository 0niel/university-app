import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/compare/comparison_logic.dart';
import 'package:rtu_mirea_app/schedule/view/compare/widgets/comparison_day_details.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/compare_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'widgets/group_picker_results_skeleton.dart';
part 'widgets/group_picker_sheet.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  DateTime _day = dateOnly(DateTime.now());
  Group? _friendGroup;
  List<SchedulePart> _friendSchedule = const [];
  bool _loadingFriend = false;
  bool _friendError = false;
  int _revision = 0;
  bool _weekView = false;

  Future<void> _pickFriend() async {
    final comparison = context.read<ScheduleComparisonCubit>();
    final previous = comparison.friend;
    await showCompareSheet(context);
    if (mounted && comparison.friend != previous) {
      _revision++;
      setState(() {
        _friendGroup = null;
        _friendError = false;
        _loadingFriend = false;
        _weekView = false;
      });
    }
  }

  Future<void> _pickFriendGroup() async {
    final group = await showAppSheet<Group>(
      context,
      title: context.l10n.comparePickerTitle,
      subtitle: context.l10n.comparePickerDescription,
      child: _GroupPickerSheet(repository: context.read<ScheduleRepository>()),
    );
    if (group != null && mounted) await _loadFriendSchedule(group);
  }

  Future<void> _loadFriendSchedule(Group group) async {
    final revision = ++_revision;
    setState(() {
      _friendGroup = group;
      _friendSchedule = const [];
      _loadingFriend = true;
      _friendError = false;
    });
    try {
      final response = await context.read<ScheduleRepository>().getSchedule(
        group: group.name,
      );
      if (!mounted || revision != _revision) return;
      setState(() {
        _friendSchedule = response.data;
        _loadingFriend = false;
      });
      context.read<ScheduleComparisonCubit?>()?.start(
        SelectedGroupSchedule(group: group, schedule: response.data),
      );
    } on Exception {
      if (!mounted || revision != _revision) return;
      setState(() {
        _loadingFriend = false;
        _friendError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ScheduleBloc>().state;
    final preferences =
        context.watch<SchedulePreferencesCubit?>()?.state ??
        const SchedulePreferencesState();
    final display =
        context.watch<ScheduleDisplayCubit?>()?.state ??
        const ScheduleDisplayState();
    final comparison = context.watch<ScheduleComparisonCubit?>();
    final activities =
        context.watch<UserActivitiesCubit?>()?.state.activities ?? const [];
    final selected = state.selectedSchedule;
    final changesCubit = context.watch<ScheduleChangesCubit?>();
    final request = changesRequestFor(selected);
    final changes =
        request != null &&
            changesCubit != null &&
            changesCubit.matchesTarget(request.$1, request.$2)
        ? changesCubit.state.changes
        : const <ScheduleChange>[];
    final group = _friendGroup;
    final friend = group == null
        ? comparison?.friend
        : _loadingFriend || _friendError
        ? null
        : SelectedGroupSchedule(group: group, schedule: _friendSchedule);
    final friendName =
        group == null && comparison?.friendName.isNotEmpty == true
        ? comparison!.friendName
        : friend?.name ?? group?.name ?? l10n.comparePickGroup;
    final myOccupancy = comparisonOccupancyForDay(
      day: _day,
      schedule: selected?.schedule ?? const [],
      activities: activities,
      includeLessons: false,
    );
    final friendOccupancy = comparisonOccupancyForDay(
      day: _day,
      schedule: friend?.schedule ?? const [],
      activities: const [],
      includeLessons: false,
    );
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.compareTitle,
              subtitle: l10n.compareSubtitle,
              onBack: () => Navigator.of(context).maybePop(),
              actions: [
                if (context.read<FriendsRepository?>() != null &&
                    comparison != null)
                  AppHeaderAction(
                    icon: AppLineIcon.people,
                    semanticsLabel: l10n.scheduleCompareFriend,
                    onTap: _pickFriend,
                  ),
                AppHeaderAction(
                  icon: AppLineIcon.plus,
                  semanticsLabel: l10n.comparePick,
                  onTap: _pickFriendGroup,
                ),
              ],
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  AppListGroup(
                    children: [
                      AppListRow(
                        title: selected?.name ?? l10n.compareMySchedule,
                        subtitle: l10n.compareYou,
                        leading: AppAvatar(
                          name: selected?.name ?? l10n.compareYou,
                          size: 40,
                        ),
                        strong: true,
                      ),
                      AppListRow(
                        key: const ValueKey('comparison-pick-schedule'),
                        title: friendName,
                        subtitle: friend == null
                            ? l10n.compareTapToPick
                            : '${friend.name} · ${l10n.compareChangeSchedule}',
                        leading: friend == null
                            ? const AppLineIconWidget(AppLineIcon.plus)
                            : AppAvatar(name: friendName, size: 40),
                        strong: true,
                        onTap: _pickFriendGroup,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_loadingFriend)
                    const Column(
                      spacing: AppSpacing.md,
                      children: [
                        AppSkeleton(height: AppControlSize.touchTarget),
                        AppSkeleton(height: 360),
                      ],
                    )
                  else if (_friendError)
                    AppErrorState(
                      title: l10n.compareLoadError,
                      message: l10n.lessonDetailsCheckConnection,
                      primaryLabel: l10n.retry,
                      onPrimary: () => _loadFriendSchedule(group!),
                      footnote: null,
                    )
                  else if (selected == null)
                    AppEmptyState(
                      title: l10n.compareMySchedule,
                      subtitle: l10n.noScheduleSelected,
                    )
                  else if (friend == null)
                    AppEmptyState(
                      title: l10n.comparePickGroup,
                      subtitle: l10n.compareEmptyHint,
                      actionLabel: l10n.comparePick,
                      onAction: _pickFriendGroup,
                    )
                  else ...[
                    AppSegmentedControl<bool>(
                      options: [
                        AppSegmentedOption(
                          value: false,
                          label: l10n.compareDayView,
                        ),
                        AppSegmentedOption(
                          value: true,
                          label: l10n.compareWeekView,
                        ),
                      ],
                      value: _weekView,
                      onChanged: (value) => setState(() => _weekView = value),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    if (_weekView) ...[
                      ScheduleWeekView(
                        day: _day,
                        schedule: selected.schedule,
                        changes: changes,
                        preferences: preferences,
                        display: display,
                        activities: activities,
                        friend: friend,
                        onCompare: _pickFriendGroup,
                        onDay: (value) => setState(() {
                          _day = dateOnly(value);
                          _weekView = false;
                        }),
                      ),
                      const SizedBox(height: AppSpacing.section),
                    ],
                    ComparisonDayDetails(
                      day: _day,
                      mine: lessonsOnDay(selected.schedule, _day)
                          .where(
                            (lesson) =>
                                !isCancelled(changeFor(changes, lesson, _day)),
                          )
                          .toList(),
                      friends: lessonsOnDay(friend.schedule, _day),
                      myName: selected.name,
                      friendName: friendName,
                      onDay: (value) => setState(() => _day = dateOnly(value)),
                      myBusyRanges: myOccupancy.ranges,
                      friendBusyRanges: friendOccupancy.ranges,
                      myUncertainFrom: myOccupancy.uncertainFrom,
                      friendUncertainFrom: friendOccupancy.uncertainFrom,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
