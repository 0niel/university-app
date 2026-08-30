part of 'polls_view.dart';

class _PollSkeletonCard extends StatelessWidget {
  const _PollSkeletonCard({
    required this.questionLines,
    required this.optionCount,
  });

  final int questionLines;
  final int optionCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NinjaSkeleton(height: 16, widthFactor: 0.85),
            if (questionLines > 1) ...[
              const SizedBox(height: 6),
              const NinjaSkeleton(height: 16, widthFactor: 0.55),
            ],
            const SizedBox(height: 12),
            for (var index = 0; index < optionCount; index++) ...[
              const NinjaSkeleton(height: 65, radius: NinjaRadius.control),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 2),
            const NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
          ],
        ),
      ),
    );
  }
}
