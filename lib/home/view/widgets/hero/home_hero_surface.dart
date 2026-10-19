import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class HomeHeroSurface extends StatelessWidget {
  const HomeHeroSurface({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.card),
      gradient: AppGlassTheme.of(context).enabled
          ? RadialGradient(
              center: Alignment.topRight,
              radius: AppGradientRadius.hero,
              colors: [
                context.colors.accent.withValues(alpha: .18),
                context.colors.accent.withValues(alpha: 0),
              ],
            )
          : null,
    ),
    child: AppGlassSurface(
      borderRadius: AppRadius.card,
      tone: AppGlassTone.accent,
      tint: context.colors.accent,
      child: AppPressable(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}
