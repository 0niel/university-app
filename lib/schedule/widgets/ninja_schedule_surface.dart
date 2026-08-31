import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaScheduleSurface extends StatelessWidget {
  const NinjaScheduleSurface({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: child,
    );

    if (onTap == null) return content;
    if (semanticLabel case final label?) {
      return AppPressable(
        onTap: onTap,
        semanticsLabel: label,
        semanticsButton: true,
        child: content,
      );
    }
    return Semantics(
      button: true,
      child: AppPressable(onTap: onTap, child: content),
    );
  }
}
