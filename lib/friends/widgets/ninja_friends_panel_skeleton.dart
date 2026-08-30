part of 'ninja_friends_panel.dart';

class _NinjaFriendsPanelSkeleton extends StatelessWidget {
  const _NinjaFriendsPanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: const Column(
        children: [
          _FriendRowSkeleton(),
          _FriendRowSkeleton(),
          _FriendRowSkeleton(),
          _FriendRowSkeleton(),
        ],
      ),
    );
  }
}
