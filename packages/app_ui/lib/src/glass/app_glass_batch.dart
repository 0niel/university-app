import 'package:app_ui/src/glass/app_glass_backend.dart';
import 'package:app_ui/src/glass/app_glass_optics.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:app_ui/src/glass/app_glass_theme.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

class AppGlassBatch extends StatefulWidget {
  const AppGlassBatch({required this.child, super.key})
    : _excluded = false,
      _controls = false;

  const AppGlassBatch.controls({required this.child, super.key})
    : _excluded = false,
      _controls = true;

  const AppGlassBatch.exclude({required this.child, super.key})
    : _excluded = true,
      _controls = false;

  final Widget child;
  final bool _excluded;
  final bool _controls;

  @override
  State<AppGlassBatch> createState() => _AppGlassBatchState();
}

class _AppGlassBatchState extends State<AppGlassBatch> {
  final _backdropKey = BackdropKey();

  @override
  Widget build(BuildContext context) {
    final enabled = !widget._excluded && AppGlassTheme.of(context).enabled;
    final sharedLayer = widget._controls && AppGlassBackend.useGpu;
    final content = AppGlassRendererScope(
      backdropKey: enabled ? _backdropKey : null,
      sharedLayer: enabled && sharedLayer,
      child: widget.child,
    );
    return LiquidGlassBatch(
      enabled: enabled,
      child: sharedLayer
          ? AppGlassPhysicalViewport(
              child: renderer.LiquidGlassLayer(
                settings: AppGlassOptics.settingsFor(
                  Theme.of(context).brightness,
                ),
                backdropKey: _backdropKey,
                child: MediaQuery(data: MediaQuery.of(context), child: content),
              ),
            )
          : content,
    );
  }
}
