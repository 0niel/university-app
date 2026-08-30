part of 'mini_app_stats_page.dart';

class _LeftLabel extends StatelessWidget {
  const _LeftLabel({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: 6),
      child: Text(
        '${value.toInt()}',
        style: NinjaText.tabular(
          NinjaText.helper.copyWith(color: context.ninja.muted),
        ),
        textAlign: .right,
      ),
    );
  }
}
