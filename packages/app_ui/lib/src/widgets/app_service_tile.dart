import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_skeleton.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum _ServiceTileStyle { regular, compact, skeleton }

class AppServiceTile extends StatelessWidget {
  const AppServiceTile({
    required this.emoji,
    required this.color,
    super.key,
    this.label,
    this.semanticsLabel,
    this.solid = false,
    this.onTap,
    this.size = 56,
  }) : icon = null,
       _style = _ServiceTileStyle.regular;

  const AppServiceTile.icon({
    required this.icon,
    required this.color,
    super.key,
    this.label,
    this.semanticsLabel,
    this.solid = false,
    this.onTap,
    this.size = 56,
  }) : emoji = null,
       _style = _ServiceTileStyle.regular;

  const AppServiceTile.compact({
    required this.icon,
    required this.color,
    required this.label,
    super.key,
    this.semanticsLabel,
    this.onTap,
  }) : emoji = null,
       solid = false,
       size = 48,
       _style = _ServiceTileStyle.compact;

  const AppServiceTile.skeleton({super.key})
    : emoji = null,
      icon = null,
      color = const Color(0x00000000),
      label = null,
      semanticsLabel = null,
      solid = false,
      onTap = null,
      size = 48,
      _style = _ServiceTileStyle.skeleton;

  final String? emoji;
  final Widget? icon;
  final Color color;
  final String? label;
  final String? semanticsLabel;
  final bool solid;
  final VoidCallback? onTap;
  final double size;
  final _ServiceTileStyle _style;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final compact = _style != _ServiceTileStyle.regular;
    final loading = _style == _ServiceTileStyle.skeleton;
    final radius = compact ? AppRadius.lg : size * .3;
    final labelText = label;
    final iconContent = Center(
      child: icon == null
          ? Text(
              emoji ?? '',
              style: AppText.sans(size * .46, FontWeight.w500, height: 1),
            )
          : IconTheme(
              data: IconThemeData(
                color: solid ? colors.onAccent : color,
                size: AppIconSize.lg,
              ),
              child: SizedBox.square(
                dimension: AppIconSize.lg,
                child: FittedBox(child: icon),
              ),
            ),
    );
    final tile = SizedBox.square(
      dimension: size,
      child: loading
          ? NinjaSkeleton(height: size, width: size, radius: radius)
          : solid
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: iconContent,
            )
          : AppGlassSurface(
              borderRadius: radius,
              tint: color,
              tone: AppGlassTone.subtle,
              child: iconContent,
            ),
    );
    final content = Padding(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 2, vertical: 8)
          : EdgeInsets.zero,
      child: labelText == null && !loading
          ? tile
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                tile,
                SizedBox(height: compact ? 7 : AppSpacing.sm),
                if (loading)
                  NinjaSkeleton(
                    height:
                        MediaQuery.textScalerOf(context).scale(
                          AppText.quickActionLabel.fontSize!,
                        ) *
                        AppText.quickActionLabel.height!,
                    widthFactor: .6,
                  )
                else
                  Text(
                    labelText!,
                    maxLines: compact
                        ? MediaQuery.textScalerOf(context).scale(1) > 1.5
                              ? 3
                              : 1
                        : 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        (compact
                                ? AppText.quickActionLabel
                                : AppText.subtextStrong)
                            .copyWith(color: colors.ink),
                  ),
              ],
            ),
    );
    if (loading) return ExcludeSemantics(child: content);
    return AppPressable(
      onTap: onTap,
      enabled: onTap != null,
      semanticsLabel: semanticsLabel ?? labelText ?? emoji ?? '',
      semanticsButton: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Align(widthFactor: 1, heightFactor: 1, child: content),
      ),
    );
  }
}
