part of 'searchable_entity_picker.dart';

class _SearchableEntityPickerSkeleton extends StatelessWidget {
  const _SearchableEntityPickerSkeleton();

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          for (var index = 0; index < 5; index++)
            const Row(
              spacing: 12,
              children: [
                NinjaSkeleton(width: 24, height: 24, radius: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 4,
                    children: [
                      NinjaSkeleton.bar(widthFactor: 0.55),
                      NinjaSkeleton.bar(height: 10, widthFactor: 0.35),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
