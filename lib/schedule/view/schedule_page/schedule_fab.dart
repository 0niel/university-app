part of '../schedule_page.dart';

class _ScheduleFab extends StatelessWidget {
  const _ScheduleFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return NinjaFab(
      icon: AppLineIconWidget(.plus, size: 24, color: context.ninja.onInk),
      tooltip: context.l10n.addActivity,
      onPressed: onPressed,
    );
  }
}
