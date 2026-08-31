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
    final colors = context.ninja;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: .ellipsis,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$done / $total',
          style: NinjaText.tabular(
            NinjaText.microLabel.copyWith(color: colors.mutedDark),
          ),
        ),
      ],
    );
  }
}
