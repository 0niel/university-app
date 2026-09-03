import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/contributors/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'contributor_card_skeleton.dart';

class ContributorsContent extends StatelessWidget {
  const ContributorsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<ContributorsBloc, ContributorsState>(
      listener: (context, state) {
        if (state.status == .failure) {
          NinjaToastHost.maybeOf(context)?.show(
            NinjaToastData(
              message: context.l10n.errorLoadingContributors,
              showCheck: false,
            ),
          );
        }
      },
      builder: (context, state) => NinjaStateSwitcher(
        child: _content(context, state, colors),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    ContributorsState state,
    AppColors colors,
  ) {
    if (state.status == .failure && state.contributors.contributors.isEmpty) {
      return Padding(
        key: const ValueKey('contributors-failure'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
        ),
        child: NinjaErrorCard(
          title: context.l10n.errorLoadingContributors,
          message: context.l10n.tryAgain,
          actionLabel: context.l10n.retry,
          onAction: () => context.read<ContributorsBloc>().add(
            const ContributorsRequested(),
          ),
        ),
      );
    }
    final isLoading =
        (state.status == .initial || state.status == .loading) &&
        state.contributors.contributors.isEmpty;
    final items = state.contributors.contributors;
    if (!isLoading && items.isEmpty) {
      return const SizedBox.shrink(key: ValueKey('contributors-empty'));
    }

    return NinjaSkeletonGroup(
      key: ValueKey(isLoading ? 'contributors-loading' : 'contributors-list'),
      excludeSemantics: false,
      pulse: isLoading,
      child: SizedBox(
        height: 177,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: isLoading ? 4 : items.length,
          itemBuilder: (context, index) {
            if (isLoading) return _ContributorCardSkeleton(colors: colors);
            final contributor = items.elementAtOrNull(index);
            if (contributor == null) return const SizedBox.shrink();
            return ContributorCard(contributor: contributor);
          },
          separatorBuilder: (_, _) => const SizedBox(width: 10),
        ),
      ),
    );
  }
}
