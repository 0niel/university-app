part of '../people_widgets.dart';

class NinjaPeopleLoadingSkeleton extends StatelessWidget {
  const NinjaPeopleLoadingSkeleton({required this.tab, super.key});

  final PeopleTab tab;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: switch (tab) {
        .friends => const NinjaFriendsTabSkeleton(),
        .group => const NinjaGroupTabSkeleton(),
      },
    );
  }
}
