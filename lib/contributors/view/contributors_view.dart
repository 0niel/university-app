import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contributors_bloc.dart';
import '../widgets/widgets.dart';

class ContributorsView extends StatelessWidget {
  const ContributorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContributorsBloc>(
      create: (context) => ContributorsBloc(
        communityRepository: context.read<CommunityRepository>(),
      )..add(const ContributorsLoadRequest()),
      child: const _ContributorsView(),
    );
  }
}

class _ContributorsView extends StatelessWidget {
  const _ContributorsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContributorsBloc, ContributorsState>(
      listener: (context, state) {
        if (state.status == ContributorsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Ошибка при загрузке контрибьюторов'),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status == ContributorsStatus.loading) {
          return SizedBox(
            height: 177,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return const SkeletonContributorCard();
              },
            ),
          );
        } else if (state.status == ContributorsStatus.loaded) {
          return SizedBox(
            height: 177,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: state.contributors.contributors.length,
              itemBuilder: (context, index) {
                final contributor = state.contributors.contributors[index];
                return ContributorCard(contributor: contributor);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
