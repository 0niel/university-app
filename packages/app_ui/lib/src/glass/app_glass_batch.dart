import 'package:app_ui/src/glass/app_glass_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class AppGlassBatch extends StatelessWidget {
  const AppGlassBatch({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => LiquidGlassBatch(
    enabled: AppGlassTheme.of(context).enabled,
    child: child,
  );
}
