import 'package:app_ui/src/glass/app_glass_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

class AppGlassLens extends StatelessWidget {
  const AppGlassLens({
    required this.style,
    required this.child,
    required this.borderRadius,
    required this.fallbackColor,
    super.key,
  });

  final LiquidGlassStyle style;
  final Widget child;
  final double borderRadius;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final view = View.of(context);
    final enabled = AppGlassTheme.of(context).enabled;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: IgnorePointer(
                child: enabled
                    ? MediaQuery(
                        data: media.copyWith(
                          size: view.physicalSize / view.devicePixelRatio,
                          devicePixelRatio: view.devicePixelRatio,
                        ),
                        child: LiquidGlassLens(
                          style: style,
                          child: const SizedBox.expand(),
                        ),
                      )
                    : ColoredBox(color: fallbackColor),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
