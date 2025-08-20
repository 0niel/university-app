import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/contributors_bloc.dart';
import '../widgets/widgets.dart';

class ContributorsView extends StatelessWidget {
  const ContributorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContributorsBloc>(
      create:
          (context) => ContributorsBloc(
            communityRepository: context.read<CommunityRepository>(),
          )..add(const ContributorsLoadRequest()),
      child: const _ContributorsView(),
    );
  }
}

class _ContributorsView extends StatelessWidget {
  const _ContributorsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContributorsBloc, ContributorsState>(
      listener: (context, state) {
        if (state.status == ContributorsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.errorLoadingContributors)),
            );
        }
      },
      builder: (context, state) {
        var items = state.contributors.contributors;

        if (state.status == ContributorsStatus.loading) {
          items = List.filled(
            10,
            Contributor(
              login: BoneMock.name,
              avatarUrl: '',
              htmlUrl: '',
              contributions: 5,
            ),
          );
        }

        return Skeletonizer(
          effect: ShimmerEffect(
            baseColor: Theme.of(context).extension<AppColors>()!.shimmerBase,
            highlightColor:
                Theme.of(context).extension<AppColors>()!.shimmerHighlight,
          ),
          enabled: state.status == ContributorsStatus.loading,
          child: SizedBox(
            height: 177,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final contributor = items[index];
                return ContributorCard(contributor: contributor);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
        );
      },
    );
  }
}
