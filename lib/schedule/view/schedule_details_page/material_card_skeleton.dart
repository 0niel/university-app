part of '../schedule_details_page.dart';

class _MaterialCardSkeleton extends StatelessWidget {
  const _MaterialCardSkeleton();
  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: const Row(
        children: [
          NinjaSkeleton.avatar(size: 46),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                NinjaSkeleton.bar(widthFactor: 0.65),
                SizedBox(height: 6),
                Row(
                  spacing: 6,
                  children: [
                    NinjaSkeleton(width: 16, height: 16),
                    NinjaSkeleton(width: 110, height: 10),
                  ],
                ),
                SizedBox(height: 8),
                NinjaSkeleton(width: 90, height: 10),
              ],
            ),
          ),
          SizedBox(width: 10),
          NinjaSkeleton(width: 34, height: 34),
        ],
      ),
    );
  }
}
