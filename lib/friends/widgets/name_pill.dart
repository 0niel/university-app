part of 'friend_marker.dart';

class _NamePill extends StatelessWidget {
  const _NamePill({
    required this.label,
    required this.color,
    this.freshness = '',
  });

  final String label;
  final Color color;
  final String freshness;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: NinjaText.microLabel.copyWith(color: colors.ink),
          ),
          if (freshness.isNotEmpty)
            Text(
              freshness,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.helper.copyWith(fontSize: 10, color: color),
            ),
        ],
      ),
    );
  }
}
