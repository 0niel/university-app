part of 'mini_app_stats_page.dart';

class _TotalsStrip extends StatelessWidget {
  const _TotalsStrip({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(child: children[index]),
        ],
      ],
    );
  }
}
