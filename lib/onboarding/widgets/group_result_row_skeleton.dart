part of '../view/onboarding_page.dart';

class _GroupResultRowSkeleton extends StatelessWidget {
  const _GroupResultRowSkeleton({this.widthFactor = 0.55});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .fromLTRB(18, 14, 18, 14),
        child: SizedBox(
          height: 19,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: NinjaSkeleton.bar(height: 14, widthFactor: widthFactor),
          ),
        ),
      ),
    );
  }
}
