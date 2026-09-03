part of 'friend_marker.dart';

class _NamePill extends StatelessWidget {
  const _NamePill({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(
        horizontal: AppSpacing.xsm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.focusOutline),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: .ellipsis,
        style: AppText.sans(
          10,
          FontWeight.w700,
        ).copyWith(color: color ?? colors.ink),
      ),
    );
  }
}
