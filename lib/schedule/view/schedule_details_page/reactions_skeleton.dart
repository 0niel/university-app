part of '../schedule_details_page.dart';

class _ReactionsSkeleton extends StatelessWidget {
  const _ReactionsSkeleton({super.key});

  static const _pillWidths = <double>[58, 64, 54, 70, 56, 62];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: Row(
        children: [
          for (final (index, width) in _pillWidths.indexed) ...[
            if (index > 0) const SizedBox(width: 8),
            NinjaSkeleton(width: width, height: 42, radius: NinjaRadius.pill),
          ],
        ],
      ),
    );
  }
}
