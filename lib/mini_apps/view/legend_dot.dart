part of 'mini_app_stats_page.dart';

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: 6,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: .circle),
        ),
        Text(
          label,
          style: NinjaText.helper.copyWith(color: context.ninja.muted),
        ),
      ],
    );
  }
}
