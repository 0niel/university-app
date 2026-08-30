part of '../schedule_page.dart';

class _WeekTodayPill extends StatelessWidget {
  const _WeekTodayPill();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Text(
        context.l10n.today,
        style: NinjaText.badge.copyWith(color: colors.brandInk),
      ),
    );
  }
}
