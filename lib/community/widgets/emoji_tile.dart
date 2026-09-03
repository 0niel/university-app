import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class EmojiTile extends StatelessWidget {
  const EmojiTile({
    super.key,
    this.emoji,
    this.icon,
    this.size = AppControlSize.iconButton,
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
    final colors = context.colors;
    final iconValue = icon;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: .circular(AppRadius.field),
      ),
      child: iconValue != null
          ? AppLineIconWidget(
              iconValue,
              size: emojiSize,
              color: colors.accent,
            )
          : Text(emoji!, style: TextStyle(fontSize: emojiSize)),
    );
  }
}
