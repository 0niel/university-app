part of 'teacher_profile_page.dart';

class _ReviewCardSkeleton extends StatelessWidget {
  const _ReviewCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: const Column(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              NinjaSkeleton(width: 32, height: 32, radius: 32 / 2),
              Expanded(child: NinjaSkeleton(width: 120, height: 12)),
              NinjaSkeleton(width: 60, height: 14),
            ],
          ),
          NinjaSkeleton.bar(height: 11, widthFactor: 0.9),
        ],
      ),
    );
  }
}
