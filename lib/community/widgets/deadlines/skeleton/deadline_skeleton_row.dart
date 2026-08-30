part of '../deadlines_skeleton.dart';

class _DeadlineSkeletonRow extends StatelessWidget {
  const _DeadlineSkeletonRow({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NinjaSkeleton(
              width: 44,
              height: 44,
              radius: NinjaRadius.control,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NinjaSkeleton(height: 17, widthFactor: 0.75),
                  const SizedBox(height: 7),
                  const NinjaSkeleton.bar(height: 10, widthFactor: 0.46),
                  const SizedBox(height: 10),
                  const NinjaSkeleton.bar(height: 11, widthFactor: 0.6),
                  if (showProgress) ...[
                    const SizedBox(height: 12),
                    const NinjaSkeleton(height: 5, radius: NinjaRadius.pill),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const NinjaSkeleton(
              width: 32,
              height: 32,
              radius: NinjaRadius.pill,
            ),
          ],
        ),
      ),
    );
  }
}
