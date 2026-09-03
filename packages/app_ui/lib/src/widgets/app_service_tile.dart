import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

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
    final colors = context.colors;
    final labelText = label;

    final tile = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: solid ? color : colors.tintOf(color),
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: icon ??
          Text(
            emoji ?? '',
            style: AppText.sans(size * .46, FontWeight.w500, height: 1),
          ),
    );

    final content = labelText == null
        ? tile
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tile,
              const SizedBox(height: AppSpacing.sm),
              Text(
                labelText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppText.subtextStrong.copyWith(color: colors.ink),
              ),
            ],
          );

    return AppPressable(
      onTap: onTap,
      semanticsLabel: labelText ?? emoji ?? '',
      child: content,
    );
  }
}
