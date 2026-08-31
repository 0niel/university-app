import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaForumAvatar extends StatelessWidget {
  const NinjaForumAvatar({required this.url, required this.size, super.key});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: ColoredBox(
          color: colors.infoTint,
          child: Image.network(
            url,
            excludeFromSemantics: true,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: AppNinjaMark(
                size: size * 0.42,
                color: colors.brandInk,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
