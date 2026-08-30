part of '../view/onboarding_page.dart';

class _GroupResultsSkeleton extends StatelessWidget {
  const _GroupResultsSkeleton({super.key});

  static const _widthFactors = [0.58, 0.44, 0.62, 0.5, 0.4];

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          for (var index = 0; index < _widthFactors.length; index++) ...[
            if (index != 0) const SizedBox(height: 10),
            _GroupResultRowSkeleton(widthFactor: _widthFactors[index]),
          ],
        ],
      ),
    );
  }
}
