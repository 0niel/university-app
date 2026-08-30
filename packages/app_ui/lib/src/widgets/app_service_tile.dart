import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppServiceTile extends StatelessWidget {
  const AppServiceTile({
    required this.emoji,
    required this.color,
    super.key,
    this.label,
    this.solid = false,
    this.onTap,
    this.size = 56,
  }) : icon = null;

  const AppServiceTile.icon({
    required this.icon,
    required this.color,
    super.key,
    this.label,
    this.solid = false,
    this.onTap,
    this.size = 56,
  }) : emoji = null;

  final String? emoji;
  final Widget? icon;
  final Color color;
  final String? label;
  final bool solid;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: solid
            ? color
            : color.withValues(alpha: colors.isDark ? 0.24 : 0.16),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: icon ??
          Text(
            emoji ?? '',
            style: TextStyle(fontSize: size * 0.46, height: 1),
          ),
    );

    final content = label == null
        ? tile
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tile,
              const SizedBox(height: AppSpacing.sm),
              Text(
                label!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: NinjaText.subtext.copyWith(
                  color: colors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return AppPressable(
      onTap: onTap,
      semanticsLabel: label ?? emoji ?? '',
      child: content,
    );
  }
}
