part of 'debug_overlay.dart';

class _DebugPanelContent extends StatelessWidget {
  const _DebugPanelContent({required this.registry, required this.onClose});

  final DebugRegistry registry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final padding = MediaQuery.paddingOf(context);

    return Material(
      color: colors.canvas,
      borderRadius: const .vertical(top: .circular(NinjaRadius.sheet)),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const .fromLTRB(16, 12, 16, 12),
            child: Column(
              spacing: 12,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: .circular(2),
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    AppNinjaMark(size: 18, color: colors.ink),
                    Text(
                      'Debug Panel',
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: 'Закрыть',
                      child: AppPressable(
                        onTap: onClose,
                        child: SizedBox.square(
                          dimension: NinjaMetrics.minTouchTarget,
                          child: Center(
                            child: AppLineIconWidget(
                              AppLineIcon.close,
                              color: colors.muted,
                              size: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.heightOf(context) * 0.55,
            ),
            child: SingleChildScrollView(
              padding: .only(bottom: padding.bottom + 16),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  if (registry.actions.isNotEmpty) ...[
                    const _SectionLabel('Действия'),
                    for (final action in registry.actions)
                      _ActionTile(action: action, onClose: onClose),
                  ],
                  if (registry.features.isNotEmpty) ...[
                    const _SectionLabel('Оверлеи'),
                    for (final feature in registry.features)
                      _FeatureTile(feature: feature),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
