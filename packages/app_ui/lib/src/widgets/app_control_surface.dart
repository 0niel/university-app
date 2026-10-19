import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/theme/app_surface_style.dart';
import 'package:app_ui/src/widgets/app_control_surface_tone.dart';
import 'package:flutter/material.dart';

export 'app_control_surface_tone.dart';

class AppControlSurface extends StatefulWidget {
  const AppControlSurface({
    required this.child,
    required this.color,
    required this.borderRadius,
    this.tone = AppControlSurfaceTone.neutral,
    this.enabled = true,
    this.pressed = false,
    this.trackDescendantFocus = false,
    super.key,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final AppControlSurfaceTone tone;
  final bool enabled;
  final bool pressed;
  final bool trackDescendantFocus;

  @override
  State<AppControlSurface> createState() => _AppControlSurfaceState();
}

class _AppControlSurfaceState extends State<AppControlSurface> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = widget.tone == AppControlSurfaceTone.accent;
    final quiet = widget.tone == AppControlSurfaceTone.quiet;
    final glass = widget.tone == AppControlSurfaceTone.glass;
    final highlighted = widget.enabled && (_hovered || _focused);
    final color = highlighted && !accent
        ? Color.alphaBlend(
            colors.accent.withValues(alpha: colors.isDark ? .07 : .04),
            widget.color,
          )
        : widget.color;
    final radius = BorderRadius.circular(widget.borderRadius);
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    Widget surface = AnimatedContainer(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: glass ? Colors.transparent : color,
        borderRadius: radius,
        gradient: glass || quiet || !widget.enabled
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    colors.white.withValues(
                      alpha: accent ? (widget.pressed ? .02 : .06) : .015,
                    ),
                    color,
                  ),
                  color,
                ],
              ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: quiet
            ? null
            : !_focused || !widget.enabled
            ? glass || accent
                  ? null
                  : AppSurfaceStyle.outline(context)
            : Border.all(
                color: colors.accent.withValues(alpha: .7),
                width: 1.5,
              ),
      ),
      child: widget.child,
    );
    if (glass) {
      surface = AppGlassSurface(
        role: AppGlassRole.control,
        borderRadius: widget.borderRadius,
        color: color,
        child: surface,
      );
    }
    if (widget.trackDescendantFocus) {
      surface = Focus(
        canRequestFocus: false,
        skipTraversal: true,
        includeSemantics: false,
        onFocusChange: (focused) {
          if (_focused != focused) setState(() => _focused = focused);
        },
        child: surface,
      );
    }
    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: (_) => setState(() => _hovered = false),
      child: surface,
    );
  }
}
