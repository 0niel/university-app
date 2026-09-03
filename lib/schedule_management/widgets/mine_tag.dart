part of 'primary_schedule_card.dart';

class _MineTag extends StatelessWidget {
  const _MineTag();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors.ink.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        context.l10n.scheduleHubMineBadge,
        style: AppText.badge.copyWith(color: colors.ink),
      ),
    );
  }
}
