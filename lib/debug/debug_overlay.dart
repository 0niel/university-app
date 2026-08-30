import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/debug/debug_registry.dart';

part 'action_tile.dart';
part 'debug_fab.dart';
part 'feature_tile.dart';
part 'debug_overlay_content.dart';
part 'debug_panel_content.dart';
part 'section_label.dart';

class DebugOverlay extends StatelessWidget {
  const DebugOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;
    return _DebugOverlayContent(child: child);
  }
}
