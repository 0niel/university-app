part of '../compare_page.dart';

class _SlotCellSkeleton extends StatelessWidget {
  const _SlotCellSkeleton();

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
        spacing: 6,
        children: [
          NinjaSkeleton.bar(widthFactor: 0.85),
          NinjaSkeleton.bar(widthFactor: 0.55),
        ],
      ),
    );
  }
}
