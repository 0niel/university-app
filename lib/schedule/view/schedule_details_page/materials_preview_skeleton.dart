part of '../schedule_details_page.dart';

class _MaterialsPreviewSkeleton extends StatelessWidget {
  const _MaterialsPreviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .only(bottom: 12),
    child: Column(
      children: [
        _MaterialInlineRowSkeleton(),
        _MaterialInlineRowSkeleton(),
        _MaterialInlineRowSkeleton(),
      ],
    ),
  );
}
