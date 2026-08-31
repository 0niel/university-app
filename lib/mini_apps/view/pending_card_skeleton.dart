part of 'mini_apps_moderation_page.dart';

class _PendingCardSkeleton extends StatelessWidget {
  const _PendingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Column(
        children: [
          MiniAppCardSkeleton(),
          Padding(
            padding: .fromLTRB(0, 10, 0, 14),
            child: Column(
              spacing: 8,
              children: [
                NinjaSkeleton(height: 44, radius: 9),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: NinjaSkeleton(height: 44, radius: 9)),
                    Expanded(child: NinjaSkeleton(height: 44, radius: 9)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
