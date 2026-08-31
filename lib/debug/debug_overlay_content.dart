part of 'debug_overlay.dart';

class _DebugOverlayContent extends StatefulWidget {
  const _DebugOverlayContent({required this.child});

  final Widget child;

  @override
  State<_DebugOverlayContent> createState() => _DebugOverlayContentState();
}

class _DebugOverlayContentState extends State<_DebugOverlayContent> {
  Offset? _fabOffset;
  bool _panelOpen = false;

  void _openPanel() => setState(() => _panelOpen = true);
  void _closePanel() => setState(() => _panelOpen = false);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: DebugRegistry.instance,
      builder: (context, _) {
        final registry = DebugRegistry.instance;
        final media = MediaQuery.of(context);
        final size = media.size;
        final fabOffset =
            _fabOffset ??
            Offset(
              size.width - 32,
              (size.height * 0.30).clamp(
                media.padding.top + 8,
                size.height - media.padding.bottom - 32,
              ),
            );
        final activeFeatures = registry.features
            .where((feature) => feature.enabled)
            .toList();

        return Stack(
          children: [
            widget.child,
            for (final feature in activeFeatures)
              Positioned.fill(
                child: IgnorePointer(child: feature.builder(context)),
              ),
            if (_panelOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closePanel,
                  child: ColoredBox(
                    color: context.ninja.ink.withValues(alpha: 0.5),
                  ),
                ),
              ),
            if (_panelOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _DebugPanelContent(
                  registry: registry,
                  onClose: _closePanel,
                ),
              ),
            if (!_panelOpen)
              Positioned(
                left: fabOffset.dx,
                top: fabOffset.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _fabOffset = Offset(
                        (fabOffset.dx + details.delta.dx).clamp(
                          0,
                          size.width - 30,
                        ),
                        (fabOffset.dy + details.delta.dy).clamp(
                          0,
                          size.height - 30,
                        ),
                      );
                    });
                  },
                  child: _DebugFab(onTap: _openPanel),
                ),
              ),
          ],
        );
      },
    );
  }
}
