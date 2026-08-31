import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_filter_row.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_group.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_overview.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadlines_skeleton.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'body/deadline_groups.dart';
part 'body/empty_deadlines.dart';
part 'body/load_failure.dart';

class DeadlinesBody extends StatelessWidget {
  const DeadlinesBody({
    required this.state,
    required this.onToggle,
    required this.onCreate,
    super.key,
  });

  final DeadlinesState state;
  final ValueChanged<String> onToggle;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final isLoading = state.status == .loading && state.deadlines.isEmpty;
    final isFailure = state.status == .failure && state.deadlines.isEmpty;
    final isEmpty = state.visibleDeadlines.isEmpty;
    return RefreshIndicator(
      backgroundColor: colors.surface,
      color: colors.brand,
      onRefresh: context.read<DeadlinesCubit>().load,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CommunityPageHeader(title: context.l10n.deadlinesTitle),
          ),
          SliverToBoxAdapter(
            child: NinjaStateSwitcher(
              child: _head(context, isLoading, isFailure),
            ),
          ),
          if (!isLoading && !isFailure)
            if (isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
                  32,
                ),
                sliver: SliverToBoxAdapter(
                  child: _EmptyDeadlines(
                    key: const ValueKey('deadlines-empty'),
                    onCreate: onCreate,
                  ),
                ),
              )
            else ...[
              ..._deadlineGroupSlivers(
                context,
                state: state,
                onToggle: onToggle,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
        ],
      ),
    );
  }

  Widget _head(BuildContext context, bool isLoading, bool isFailure) {
    if (isLoading) {
      return const DeadlinesSkeleton(key: ValueKey('deadlines-loading'));
    }
    if (isFailure) {
      return Padding(
        key: const ValueKey('deadlines-failure'),
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          18,
          NinjaMetrics.screenPadding,
          32,
        ),
        child: _LoadFailure(onRetry: context.read<DeadlinesCubit>().load),
      );
    }
    return Column(
      key: const ValueKey('deadlines-overview'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            16,
            NinjaMetrics.screenPadding,
            0,
          ),
          child: DeadlineOverview(
            deadlines: state.deadlines,
            isCreating: state.isCreating,
            onCreate: onCreate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: DeadlineFilterRow(
            selected: state.filter,
            activeCount: state.activeDeadlines.length,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
