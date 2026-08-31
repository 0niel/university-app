part of '../schedule_details_page.dart';

class _MaterialsPageSkeleton extends StatelessWidget {
  const _MaterialsPageSkeleton({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    spacing: 8,
    children: [
      _MaterialCardSkeleton(),
      _MaterialCardSkeleton(),
      _MaterialCardSkeleton(),
      _MaterialCardSkeleton(),
      _MaterialCardSkeleton(),
    ],
  );
}
