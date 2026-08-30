part of 'custom_schedules_page.dart';

class _CustomSchedulesMoreButton extends StatelessWidget {
  const _CustomSchedulesMoreButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    semanticsLabel: context.l10n.more,
    child: SizedBox.square(
      dimension: NinjaMetrics.minTouchTarget,
      child: Center(
        child: AppLineIconWidget(
          .more,
          size: 20,
          color: context.ninja.mutedDark,
        ),
      ),
    ),
  );
}
