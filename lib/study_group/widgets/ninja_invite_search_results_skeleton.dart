part of 'ninja_invite_sheet.dart';

class _NinjaInviteSearchResultsSkeleton extends StatelessWidget {
  const _NinjaInviteSearchResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: Column(
        children: [
          for (var index = 0; index < 3; index++)
            const Padding(
              padding: .only(bottom: 10),
              child: NinjaSkeleton(height: 76, radius: NinjaRadius.card),
            ),
        ],
      ),
    );
  }
}
