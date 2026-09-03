part of '../people_widgets.dart';

class PersonRowSkeleton extends StatelessWidget {
  const PersonRowSkeleton({
    super.key,
    this.trailingLastSeen = false,
    this.trailingTag = false,
  });

  final bool trailingLastSeen;
  final bool trailingTag;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const NinjaSkeleton.avatar(),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            spacing: 6,
            crossAxisAlignment: .start,
            children: [
              NinjaSkeleton.bar(height: 14, widthFactor: 0.55),
              NinjaSkeleton.bar(height: 11, widthFactor: 0.35),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (trailingLastSeen)
          const NinjaSkeleton(width: 48, height: 11)
        else if (trailingTag)
          const NinjaSkeleton(
            width: 64,
            height: 28,
            radius: AppRadius.skeletonSmall,
          ),
      ],
    );
  }
}
