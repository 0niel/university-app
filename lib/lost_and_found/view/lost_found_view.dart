import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/config/university_config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/config/lost_found_categories.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/widgets.dart';

class LostFoundView extends StatefulWidget {
  const LostFoundView({super.key});

  @override
  State<LostFoundView> createState() => _LostFoundViewState();
}

class _LostFoundViewState extends State<LostFoundView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _report() {
    final cubit = context.read<LostFoundCubit>();
    return showAppSheet<void>(
      context,
      title: context.l10n.lostFoundReportTitle,
      subtitle: context.l10n.lostFoundReportSub,
      child: BlocProvider.value(
        value: cubit,
        child: const LostFoundReportSheet(),
      ),
    );
  }

  Future<void> _openItem(LostFoundItem item) {
    final cubit = context.read<LostFoundCubit>();
    return showAppSheet<void>(
      context,
      child: BlocProvider.value(
        value: cubit,
        child: LostFoundItemSheet(item: item),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LostFoundState state) {
    final message = state.status == .failure
        ? context.l10n.lostFoundLoadError
        : context.l10n.lostFoundCleanupWarning;
    NinjaToastHost.maybeOf(
      context,
    )?.show(NinjaToastData(message: message, showCheck: false));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<LostFoundCubit, LostFoundState>(
      listenWhen: (previous, current) =>
          (previous.status != current.status &&
              current.status == .failure &&
              current.items.isNotEmpty) ||
          previous.cleanupWarningRevision != current.cleanupWarningRevision,
      listener: _onStateChanged,
      builder: (context, state) => Scaffold(
        backgroundColor: context.ninja.canvas,
        body: SafeArea(
          bottom: false,
          child: LostFoundBody(
            state: state,
            onItemTap: (item) => unawaited(_openItem(item)),
            onReport: () => unawaited(_report()),
            header: _header(context, state),
            categoryFilter: LostFoundCategoryPicker(
              keys: [
                'all',
                ...UniversityConfig.current.lostFoundCategoryKeys,
              ],
              value: state.category,
              labelBuilder: (key) => key == 'all'
                  ? l10n.communitiesAll
                  : LostFoundCategories.label(l10n, key),
              onChanged: context.read<LostFoundCubit>().categoryChanged,
            ),
          ),
        ).animatePageEntrance(),
      ),
    );
  }

  Widget _header(BuildContext context, LostFoundState state) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final coldLoading = state.status == .loading && state.items.isEmpty;
    final coldFailure = state.status == .failure && state.items.isEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        AppSpacing.md,
        NinjaMetrics.screenPadding,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lostFoundTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.display.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 5),
                    if (coldLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        child: NinjaSkeleton(
                          width: 120,
                          height: 11,
                          radius: 5,
                        ),
                      )
                    else
                      Text(
                        l10n.lostFoundItemsCount(state.items.length),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              NinjaIconButton(
                icon: AppLineIconWidget(
                  AppLineIcon.refresh,
                  size: 20,
                  color: colors.ink,
                ),
                tooltip: l10n.retry,
                onPressed: state.status == .loading
                    ? null
                    : () => unawaited(context.read<LostFoundCubit>().load()),
              ),
            ],
          ),
          const SizedBox(height: 22),
          NinjaInput(
            controller: _searchController,
            leadingIcon: AppLineIconWidget(
              AppLineIcon.search,
              size: 17,
              color: colors.muted,
            ),
            placeholder: l10n.lostFoundSearchHint,
            textInputAction: TextInputAction.search,
            onChanged: context.read<LostFoundCubit>().queryChanged,
          ),
          if (!coldFailure) ...[
            const SizedBox(height: AppSpacing.md),
            NinjaSegmented<LostFoundItemStatus>(
              expanded: true,
              value: state.tab,
              segments: [
                NinjaSegment(
                  value: .found,
                  label: l10n.lostFoundTabFound(state.countFor(.found)),
                ),
                NinjaSegment(
                  value: .lost,
                  label: l10n.lostFoundTabLost(state.countFor(.lost)),
                ),
              ],
              onChanged: context.read<LostFoundCubit>().tabChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            LostFoundReportCta(
              accented: !coldLoading,
              onTap: state.isCreating ? null : () => unawaited(_report()),
            ),
          ],
        ],
      ),
    );
  }
}
