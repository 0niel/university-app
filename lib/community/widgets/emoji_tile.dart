import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class EmojiTile extends StatelessWidget {
  const EmojiTile({
    super.key,
    this.emoji,
    this.icon,
    this.size = NinjaMetrics.minTouchTarget,
    this.emojiSize = 20,
  }) : assert(
         emoji != null || icon != null,
         'EmojiTile requires either emoji or icon.',
       );

  final String? emoji;

  final AppLineIcon? icon;
  final double size;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final iconValue = icon;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: .circular(NinjaRadius.control),
      ),
      child: iconValue != null
          ? AppLineIconWidget(
              iconValue,
              size: emojiSize,
              color: colors.brandInk,
            )
          : Text(emoji!, style: TextStyle(fontSize: emojiSize)),
    );
  }
}
