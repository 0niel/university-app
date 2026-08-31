part of 'primary_schedule_card.dart';

class _MineTag extends StatelessWidget {
  const _MineTag();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors.onAccentSoft.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(NinjaRadius.pill),
      ),
      child: Text(
        context.l10n.scheduleHubMineBadge,
        style: NinjaText.badge.copyWith(color: colors.onAccentSoft),
      ),
    );
  }
}
