part of 'badges_tab.dart';

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.title,
    required this.done,
    required this.total,
  });

  final String title;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: .ellipsis,
            style: AppText.title.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(width: AppSpacing.gap),
        Text(
          '$done / $total',
          style: AppText.captionSmall
              .copyWith(color: colors.muted)
              .copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        ),
      ],
    );
  }
}
