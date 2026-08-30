part of '../compare_page.dart';

class _SlotRowSkeleton extends StatelessWidget {
  const _SlotRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        spacing: 10,
        children: [
          SizedBox(
            width: 44,
            child: Padding(
              padding: .only(top: 14),
              child: NinjaSkeleton(width: 30, height: 11),
            ),
          ),
          Expanded(child: _SlotCellSkeleton()),
          Expanded(child: _SlotCellSkeleton()),
        ],
      ),
    );
  }
}
