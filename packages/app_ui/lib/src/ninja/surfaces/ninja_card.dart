import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaCard extends StatelessWidget {
  const NinjaCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.outlined = false,
    this.accent,
    this.onTap,
  });
  final Widget child;
  final EdgeInsets padding;
  final bool outlined;
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final accentColor = accent;
    final radius = BorderRadius.circular(NinjaRadius.card);

    Widget content = Padding(padding: padding, child: child);
    if (accentColor != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 3, color: accentColor),
          Expanded(child: content),
        ],
      );
    }

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: outlined ? colors.surfaceAlt : colors.surface,
        borderRadius: radius,
      ),
      child: ClipRRect(borderRadius: radius, child: content),
    );

    if (onTap == null) return card;
    return AppPressable(onTap: onTap, child: card);
  }
}
