part of 'map_skeleton.dart';

class _MapLoadingMark extends StatelessWidget {
  const _MapLoadingMark();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ExcludeSemantics(
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              shape: .circle,
            ),
            child: const NinjaSpinner(),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.mapOpeningFloor,
            style: NinjaText.subtext.copyWith(color: colors.mutedDark),
          ),
        ],
      ),
    );
  }
}
