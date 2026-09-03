part of 'teacher_profile_page.dart';

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: AppSpacing.sm,
      children: [
        _ReviewCardSkeleton(),
        _ReviewCardSkeleton(),
        _ReviewCardSkeleton(),
      ],
    );
  }
}
