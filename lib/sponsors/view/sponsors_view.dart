import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/sponsors/sponsors.dart';

class SponsorsView extends StatelessWidget {
  const SponsorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SponsorsBloc>(
      create: (context) => SponsorsBloc(
        communityRepository: context.read<CommunityRepository>(),
      )..add(const SponsorsLoadRequest()),
      child: const _SponsorsView(),
    );
  }
}

class _SponsorsView extends StatelessWidget {
  const _SponsorsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SponsorsBloc, SponsorsState>(
      listener: (context, state) {
        if (state.status == SponsorsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Ошибка при загрузке спонсоров'),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state.status == SponsorsStatus.loading) {
          return Column(
            children: List.generate(
              1,
              (index) => const SkeletonSponsorCard(),
            ),
          );
        } else if (state.status == SponsorsStatus.loaded) {
          return Column(
            children: List.generate(
              state.sponsors.sponsors.length,
              (index) {
                final sponsor = state.sponsors.sponsors[index];

                return SponsorCard(sponsor: sponsor);
              },
            ).animate(interval: 80.ms).fade(duration: 200.ms),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
