part of 'debug_overlay.dart';

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.feature});

  final DebugFeature feature;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .symmetric(horizontal: 16, vertical: 10),
      child: Row(
        spacing: 12,
        children: [
          AppLineIconWidget(
            feature.icon,
            color: feature.enabled ? colors.accent : colors.muted,
            size: 20,
          ),
          Expanded(
            child: Text(
              feature.label,
              style: AppText.body.copyWith(color: colors.ink),
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
