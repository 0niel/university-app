import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/compare/comparison_logic.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'widgets/common_window_banner.dart';
part 'widgets/compare_skeleton.dart';
part 'widgets/group_picker_results_skeleton.dart';
part 'widgets/group_picker_sheet.dart';
part 'widgets/person_card.dart';
part 'widgets/slot_cell_skeleton.dart';
part 'widgets/slot_cell.dart';
part 'widgets/slot_row_skeleton.dart';
part 'widgets/slot_row.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  DateTime _day = _dateOnly(DateTime.now());
  Group? _friendGroup;
  List<LessonSchedulePart> _friendLessons = const [];
  bool _loadingFriend = false;
  Object? _friendError;

  static DateTime _dateOnly(DateTime value) =>
      .new(value.year, value.month, value.day);

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<ScheduleBloc>().state;
    final friendGroup = _friendGroup;
    final myTitle = switch (state.selectedSchedule) {
      SelectedGroupSchedule(:final group) => group.name,
      SelectedTeacherSchedule(:final teacher) => teacher.name,
      SelectedClassroomSchedule(:final classroom) => classroom.name,
      SelectedCustomSchedule(:final name) => name,
      null => l10n.compareMySchedule,
    };
    final myLessons = lessonsOnDay(
      state.selectedSchedule?.schedule ?? const [],
      _day,
    );
    final friendLessons = lessonsOnDay(_friendLessons, _day);
    final slots = buildComparisonSlots(myLessons, friendLessons);
    final commonWindow = slots.firstWhereOrNull((slot) => slot.bothFree);
    final locale = Localizations.localeOf(context).toString();

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
              l10n.compareTitle,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
            actions: [
              NinjaIconButton(
                icon: const AppLineIconWidget(
                  .plus,
                  size: 20,
                ),
                tooltip: l10n.comparePick,
                onPressed: () => unawaited(_pickFriendGroup()),
              ),
              const SizedBox(width: 8),
            ],
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked =
                          constraints.maxWidth < 420 ||
                          MediaQuery.textScalerOf(context).scale(1) > 1.4;
                      final mine = _PersonCard(
                        label: l10n.compareYou,
                        subtitle: myTitle,
                      );
                      final friend = NinjaScheduleSurface(
                        padding: EdgeInsets.zero,
                        onTap: () => unawaited(_pickFriendGroup()),
                        semanticLabel: l10n.comparePick,
                        child: _PersonCard(
                          label: friendGroup?.name ?? l10n.comparePickGroup,
                          subtitle: friendGroup != null
                              ? l10n.compareFriend
                              : l10n.compareTapToPick,
                          muted: friendGroup == null,
                        ),
                      );
                      if (stacked) {
                        return Column(
                          children: [mine, const SizedBox(height: 10), friend],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: mine),
                          const SizedBox(width: 10),
                          Expanded(child: friend),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      NinjaIconButton(
                        icon: const AppLineIconWidget(
                          .chevronL,
                          size: 18,
                        ),
                        tooltip: l10n.previousDay,
                        onPressed: () => setState(
                          () => _day = _day.subtract(const Duration(days: 1)),
                        ),
                      ),
                      Padding(
                        padding: const .symmetric(horizontal: 14),
                        child: Text(
                          _capitalize(
                            DateFormat('EEEE, d MMMM', locale).format(_day),
                          ),
                          style: NinjaText.body.copyWith(
                            color: colors.ink,
                          ),
                        ),
                      ),
                      NinjaIconButton(
                        icon: const AppLineIconWidget(
                          .chevronR,
                          size: 18,
                        ),
                        tooltip: l10n.nextDay,
                        onPressed: () => setState(
                          () => _day = _day.add(const Duration(days: 1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  NinjaStateSwitcher(
                    child: _buildComparison(
                      context,
                      friendGroup: friendGroup,
                      slots: slots,
                      commonWindow: commonWindow,
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

  Widget _buildComparison(
    BuildContext context, {
    required Group? friendGroup,
    required List<ComparisonSlot> slots,
    required ComparisonSlot? commonWindow,
  }) {
    final l10n = context.l10n;
    if (_loadingFriend) {
      return const _CompareSkeleton(key: ValueKey('compare_skeleton'));
    }
    if (friendGroup == null) {
      return NinjaEmptyState(
        title: l10n.comparePickGroup,
        message: l10n.compareEmptyHint,
        icon: AppLineIconWidget(
          AppLineIcon.people,
          size: 20,
          color: context.ninja.muted,
        ),
        actionLabel: l10n.comparePick,
        onAction: () => unawaited(_pickFriendGroup()),
      ).animateEmptyState(key: const ValueKey('compare_pick'));
    }
    if (_friendError != null) {
      return NinjaErrorState(
        title: l10n.compareLoadError,
        message: l10n.lessonDetailsCheckConnection,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_loadFriendSchedule(friendGroup)),
      ).animateEmptyState(key: const ValueKey('compare_error'));
    }
    if (slots.isEmpty) {
      return NinjaEmptyState(
        title: l10n.compareNoLessonsBoth,
        icon: AppLineIconWidget(
          AppLineIcon.calendar,
          size: 20,
          color: context.ninja.muted,
        ),
      ).animateEmptyState(key: const ValueKey('compare_free'));
    }
    return Column(
      key: const ValueKey('compare_slots'),
      crossAxisAlignment: .stretch,
      children: [
        if (commonWindow != null) ...[
          _CommonWindowBanner(window: commonWindow),
          const SizedBox(height: 28),
        ],
        for (final (index, slot) in slots.indexed) ...[
          _SlotRow(slot: slot).animateListItem(index: index),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Future<void> _pickFriendGroup() async {
    final repository = context.read<ScheduleRepository>();
    final group = await showAppSheet<Group>(
      context,
      title: context.l10n.comparePickerTitle,
      subtitle: context.l10n.comparePickerDescription,
      heightFraction: 0.6,
      child: _GroupPickerSheet(repository: repository),
    );
    if (group != null && mounted) await _loadFriendSchedule(group);
  }

  Future<void> _loadFriendSchedule(Group group) async {
    setState(() {
      _friendGroup = group;
      _loadingFriend = true;
      _friendError = null;
    });
    try {
      final response = await context.read<ScheduleRepository>().getSchedule(
        group: group.name,
      );
      if (!mounted) return;
      setState(() {
        _friendLessons = response.data.whereType<LessonSchedulePart>().toList();
        _loadingFriend = false;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingFriend = false;
        _friendError = error;
      });
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.compareLoadError,
      );
    }
  }

  static String _capitalize(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);
}

String _compareInitials(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part.characters.firstOrNull?.toUpperCase() ?? '')
    .join();
