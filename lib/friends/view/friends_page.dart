import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_page.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_list_row.dart';
import 'package:rtu_mirea_app/friends/widgets/ninja_friends_panel.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = FriendsListCubit(friendsRepository: context.read());
      unawaited(cubit.load());
      return cubit;
    },
    child: const FriendsListView(),
  );
}

class FriendsListView extends StatefulWidget {
  const FriendsListView({super.key});

  @override
  State<FriendsListView> createState() => _FriendsListViewState();
}

class _FriendsListViewState extends State<FriendsListView> {
  Timer? _presenceTimer;

  @override
  void initState() {
    super.initState();
    _presenceTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _presenceTimer?.cancel();
    super.dispose();
  }

  Future<void> _addFriend() async {
    await Navigator.of(context).push(FindFriendsPage.route());
    if (mounted) await context.read<FriendsListCubit>().load();
  }

  Future<void> _showFriend(Friend friend) async {
    final cubit = context.read<FriendsListCubit>();
    final remove = await showAppSheet<bool>(
      context,
      child: FriendCardSheet(friend: friend),
    );
    if (remove != true || !mounted) return;
    final removed = await cubit.removeFriend(friend.userId);
    if (!removed && mounted) {
      ToastManager.showError(context, message: context.l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocBuilder<FriendsListCubit, FriendsListState>(
        builder: (context, state) {
          final now = DateTime.now();
          final friends = state.visible(now);
          final cubit = context.read<FriendsListCubit>();
          return RefreshIndicator(
            onRefresh: cubit.load,
            color: colors.accent,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: ninjaBottomInset(context) + AppSpacing.lg,
              ),
              children: [
                AppInnerHeader(
                  title: l10n.friendsTitle,
                  backSemanticsLabel: l10n.back,
                  onBack: () => Navigator.of(context).maybePop(),
                  actions: [
                    AppHeaderAction(
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: AppLineIconWidget(
                          AppLineIcon.plus,
                          color: colors.onAccent,
                          size: 20,
                          strokeWidth: 2.4,
                        ),
                      ),
                      semanticsLabel: l10n.friendsAddFriend,
                      onTap: _addFriend,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.contentGap,
                    AppSpacing.screen,
                    AppSpacing.lg,
                  ),
                  child: AppCard(
                    tinted: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                      vertical: AppSpacing.fieldGap,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.friendsCommonWindowsToday,
                                style: AppText.sans(
                                  11.5,
                                  FontWeight.w600,
                                ).copyWith(color: colors.muted),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                l10n.friendsCompareHeroTitle,
                                style: AppText.serif(
                                  22,
                                ).copyWith(color: colors.ink),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                l10n.friendsCompareHeroSub,
                                style: AppText.subtext.copyWith(
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sectionGap),
                        AppPressable(
                          semanticsLabel: l10n.friendsCompare,
                          semanticsButton: true,
                          onTap: () =>
                              const ScheduleCompareRoute().push<void>(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xxs,
                            ),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sectionGap,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Text(
                                l10n.friendsCompare,
                                style: AppText.sans(
                                  13,
                                  FontWeight.w700,
                                ).copyWith(color: colors.ink),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: AppChipGroup(
                    chips: [
                      for (final filter in FriendsFilter.values)
                        AppChip.filter(
                          label: filter == FriendsFilter.all
                              ? l10n.friendsFilterAll
                              : l10n.friendsFilterCampus,
                          selected: state.filter == filter,
                          onTap: () => cubit.setFilter(filter),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.sectionGap,
                    AppSpacing.screen,
                    0,
                  ),
                  child: friends.isNotEmpty
                      ? AppListGroup(
                          children: [
                            for (final friend in friends)
                              FriendsListRow(
                                friend: friend,
                                now: now,
                                onTap: () => _showFriend(friend),
                              ),
                          ],
                        )
                      : switch (state.status) {
                          FriendsListStatus.initial ||
                          FriendsListStatus.loading => const NinjaSkeleton(
                            height: 220,
                            radius: AppRadius.card,
                          ),
                          FriendsListStatus.failure => AppErrorState(
                            title: l10n.friendsLoadError,
                            message: null,
                            footnote: null,
                            primaryLabel: l10n.retry,
                            onPrimary: cubit.load,
                          ),
                          FriendsListStatus.loaded => AppEmptyState(
                            title: state.filter == FriendsFilter.onCampus
                                ? l10n.friendsCampusEmpty
                                : l10n.friendsEmptyTitle,
                            subtitle: state.filter == FriendsFilter.all
                                ? l10n.friendsEmptySub
                                : null,
                            actionLabel: l10n.friendsAddFriend,
                            onAction: _addFriend,
                            lineIcon: AppLineIcon.people,
                          ),
                        },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.sectionGap,
                    AppSpacing.screen,
                    0,
                  ),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.fieldGap,
                      vertical: AppSpacing.lg,
                    ),
                    onTap: () => const FriendsMapRoute().push<void>(context),
                    semanticsLabel: l10n.peopleMapOpen,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.lectureTint,
                            borderRadius: BorderRadius.circular(AppRadius.tile),
                          ),
                          child: AppLineIconWidget(
                            AppLineIcon.pin,
                            color: colors.lecture,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sectionGap),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.friendsPrivacyTitle,
                                style: AppText.cell.copyWith(color: colors.ink),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                l10n.friendsPrivacySub,
                                style: AppText.subtext.copyWith(
                                  color: colors.muted,
                                ),
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
        },
      ),
    );
  }
}
