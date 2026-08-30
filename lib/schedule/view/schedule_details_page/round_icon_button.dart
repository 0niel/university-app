part of '../schedule_details_page.dart';

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
  });

  final AppLineIcon icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return NinjaIconButton(
      icon: AppLineIconWidget(
        icon,
        size: size * .5,
        color: context.ninja.ink,
      ),
      onPressed: onTap,
    );
  }
}
