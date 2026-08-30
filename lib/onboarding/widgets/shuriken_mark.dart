part of '../view/onboarding_page.dart';

class _ShurikenMark extends StatelessWidget {
  const _ShurikenMark({required this.turns});

  final Animation<double> turns;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: turns,
      child: AppNinjaMark(size: 32, color: context.ninja.brand),
    );
  }
}
