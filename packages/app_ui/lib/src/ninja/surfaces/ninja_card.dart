import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaCard extends StatelessWidget {
  const NinjaCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sectionGap,
    ),
    this.outlined = false,
    this.accent,
    this.onTap,
    this.radius = AppRadius.card,
    this.color,
    this.tinted = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool outlined;
  final Color? accent;
  final VoidCallback? onTap;
  final double radius;
  final Color? color;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = accent;
    final borderRadius = BorderRadius.circular(radius);
    final background = color ??
        (tinted
            ? colors.tint
            : outlined
                ? colors.surface2
                : colors.surface);

    Widget content = Padding(padding: padding, child: child);
    if (accentColor != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 4, child: ColoredBox(color: accentColor)),
          Expanded(child: content),
        ],
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: borderRadius),
      child: ClipRRect(borderRadius: borderRadius, child: content),
    );

    if (onTap == null) return card;
    return AppPressable(onTap: onTap, child: card);
  }
}
