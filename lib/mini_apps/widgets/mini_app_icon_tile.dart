import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppIconTile extends StatelessWidget {
  const MiniAppIconTile({
    required this.emoji,
    required this.accent,
    super.key,
    this.size = 44,
  });

  final String emoji;
  final Color accent;
  final double size;

  static Color resolveAccent(String value, {required Color fallback}) {
    final hex = value.replaceFirst('#', '');
    if (hex.length != 6) return fallback;
    final rgb = int.tryParse(hex, radix: 16);
    return rgb == null ? fallback : Color(0xff000000 | rgb);
  }

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      size: size,
      radius: size * .32,
      background: context.colors.tintOf(accent, .2),
      child: Text(
        emoji,
        style: AppText.sans(size * .5, FontWeight.w400, height: 1),
      ),
    );
  }
}
