part of 'debug_overlay.dart';

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final DebugFeature feature;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .symmetric(horizontal: 16, vertical: 10),
      child: Row(
        spacing: 12,
        children: [
          AppLineIconWidget(
            feature.icon,
            color: feature.enabled ? colors.brand : colors.muted,
            size: 20,
          ),
          Expanded(
            child: Text(
              feature.label,
              style: NinjaText.body.copyWith(color: colors.ink),
            ),
          ),
          NinjaSwitch(
            value: feature.enabled,
            onChanged: (_) => DebugRegistry.instance.toggleFeature(feature),
          ),
        ],
      ),
    );
  }
}
