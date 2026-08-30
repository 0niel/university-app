import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppListRow extends StatelessWidget {
  const AppListRow({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isFirst = false,
    this.dense = false,
    this.onTap,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool isFirst;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final vPad = dense ? AppSpacing.sm : 14.0;
    final leadingWidget = leading;
    final subtitleText = subtitle;
    final trailingWidget = trailing;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: subtitleText == null ? title : '$title, $subtitleText',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: vPad,
          ),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppText.bodyLarge.copyWith(
                        color: colors.active,
                        fontSize: 14.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitleText != null)
                      Text(
                        subtitleText,
                        style: AppText.caption.copyWith(
                          color: colors.deactive,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: 8),
                trailingWidget,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppIconAvatar extends StatelessWidget {
  const AppIconAvatar({
    super.key,
    this.icon,
    this.emoji,
    this.color = const Color(0xFF2F7AFF),
    this.size = 40,
    this.radius = 12,
  });

  final IconData? icon;
  final String? emoji;
  final Color color;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final emoji = this.emoji;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: emoji != null
          ? Text(emoji, style: TextStyle(fontSize: size * 0.5, height: 1))
          : Icon(icon, size: size * 0.5, color: color),
    );
  }
}
