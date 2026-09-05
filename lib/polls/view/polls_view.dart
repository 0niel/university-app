import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_action.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';
import 'package:rtu_mirea_app/polls/view/polls_body.dart';
import 'package:rtu_mirea_app/polls/widgets/widgets.dart';

class PollsView extends StatefulWidget {
  const PollsView({super.key});

  @override
  State<PollsView> createState() => _PollsViewState();
}

class _PollsViewState extends State<PollsView> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _filterLabel(AppLocalizations l10n, PollFilter filter) =>
      switch (filter) {
        PollFilter.all => l10n.pollsFilterAll,
        PollFilter.active => l10n.pollsFilterActive,
        PollFilter.closed => l10n.pollsFilterClosed,
        PollFilter.mine => l10n.pollsFilterMine,
        PollFilter.participated => l10n.pollsFilterVoted,
      };

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<PollsCubit>();
    await showPollCreatorSheet(context, cubit: cubit);
  }

  Future<void> _open(BuildContext context, Poll poll) async {
    final cubit = context.read<PollsCubit>();
    final canTake = !poll.iParticipated && !poll.isEnded;
    if (canTake) {
      await showPollRunnerSheet(context, poll: poll, cubit: cubit);
    } else {
      await showPollResultsSheet(context, poll: poll);
    }
  }

  Future<void> _ownerActions(BuildContext context, Poll poll) async {
    final cubit = context.read<PollsCubit>();
    await showPollOwnerActionsSheet(context, poll: poll, cubit: cubit);
  }

  Future<void> _changeAnswers(BuildContext context, Poll poll) async {
    if (poll.isEnded || !poll.allowChange) return;
    await showPollRunnerSheet(
      context,
      poll: poll,
      cubit: context.read<PollsCubit>(),
    );
  }

  Future<void> _chooseCategory() async {
    final cubit = context.read<PollsCubit>();
    final l10n = context.l10n;
    final selected = cubit.state.category;
    await showAppSheet<void>(
      context,
      title: l10n.pollsCategoryLabel,
      child: Builder(
        builder: (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            for (final category in <PollCategory?>[
              null,
              ...PollCategory.values,
            ])
              AppRadioRow(
                title: category == null
                    ? l10n.pollsCategoryAll
                    : pollCategoryLabel(l10n, category),
                selected: selected == category,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  cubit.setCategory(category);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<PollsCubit>().state;
    final cubit = context.read<PollsCubit>();
    final isLoading =
        state.status == PollsStatus.loading && state.polls.isEmpty;
    final isFailure =
        state.status == PollsStatus.failure && state.polls.isEmpty;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.accent,
        backgroundColor: colors.surface,
        onRefresh: cubit.load,
        child: CustomScrollView(
          key: const PageStorageKey('polls-scroll'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppInnerHeader(
                title: l10n.pollsTitle,
                onBack: () => Navigator.of(context).maybePop(),
                backSemanticsLabel: l10n.back,
                trailingLabel: isLoading || isFailure
                    ? null
                    : l10n.pollsOpenCount(state.openCount),
                actions: [
                  accentHeaderAction(
                    onTap: () => unawaited(_create(context)),
                    semanticsLabel: l10n.pollsCreate,
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: AppSearchField(
                        controller: _search,
                        hintText: l10n.pollsSearchHint,
                        onChanged: cubit.setQuery,
                        onClear: () => cubit.setQuery(''),
                      ),
                    ),
                    AppIconButton(
                      key: const Key('polls-category'),
                      tooltip: l10n.pollsCategoryLabel,
                      backgroundColor: state.category == null
                          ? null
                          : colors.tint,
                      icon: const AppLineIconWidget(AppLineIcon.filter),
                      onPressed: () => unawaited(_chooseCategory()),
                    ),
                  ],
                ),
              ),
            ),
            if (state.category case final category?)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.xs,
                  AppSpacing.screen,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppButton.text(
                      key: const Key('polls-clear-category'),
                      label: pollCategoryLabel(l10n, category),
                      trailingIcon: const AppLineIconWidget(
                        AppLineIcon.close,
                        size: 16,
                      ),
                      onPressed: () => cubit.setCategory(null),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: AppChipRow<PollFilter>(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  value: state.filter,
                  onChanged: cubit.setFilter,
                  items: [
                    for (final filter in PollFilter.values)
                      AppChipRowItem(
                        value: filter,
                        label: _filterLabel(l10n, filter),
                      ),
                  ],
                ),
              ),
            ),
            if (state.status == .failure && state.polls.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.md,
                  AppSpacing.screen,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppBanner(
                        message: l10n.loadingError,
                        tone: AppBannerTone.danger,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AppButton.text(
                          label: l10n.retry,
                          onPressed: () => unawaited(cubit.load()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                cubit.hasMore
                    ? AppSpacing.lg
                    : ninjaBottomInset(context) + AppSpacing.lg,
              ),
              sliver: PollsBody(
                isLoading: isLoading,
                isFailure: isFailure,
                polls: state.polls,
                filter: state.filter,
                category: state.category,
                query: state.query,
                onRetry: () => unawaited(cubit.load()),
                onCreate: () => unawaited(_create(context)),
                onOpen: (poll) => unawaited(_open(context, poll)),
                onOwnerActions: (poll) =>
                    unawaited(_ownerActions(context, poll)),
                onChangeAnswers: (poll) =>
                    unawaited(_changeAnswers(context, poll)),
                onResults: (poll) =>
                    unawaited(showPollResultsSheet(context, poll: poll)),
              ),
            ),
            if (cubit.hasMore && state.polls.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    0,
                    AppSpacing.screen,
                    ninjaBottomInset(context) + AppSpacing.lg,
                  ),
                  child: AppButton.secondary(
                    label: l10n.pollsLoadMore,
                    expanded: true,
                    loading: state.status == .loading,
                    onPressed: state.status == .loading
                        ? null
                        : () => unawaited(cubit.load(more: true)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
