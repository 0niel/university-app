part of '../compare_page.dart';

class _CompareSkeleton extends StatelessWidget {
  const _CompareSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      children: [
        _SlotRowSkeleton(),
        _SlotRowSkeleton(),
        _SlotRowSkeleton(),
      ],
    );
  }
}
