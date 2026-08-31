part of '../changes_page.dart';

class _ChangesSkeleton extends StatelessWidget {
  const _ChangesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ChangeTimelineRowSkeleton(),
        _ChangeTimelineRowSkeleton(),
        _ChangeTimelineRowSkeleton(),
        _ChangeTimelineRowSkeleton(last: true),
      ],
    );
  }
}
