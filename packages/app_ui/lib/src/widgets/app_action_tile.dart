import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_skeleton.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/app_skeleton_text.dart';
import 'package:flutter/widgets.dart';

class AppActionTile extends StatelessWidget {
  const AppActionTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.tint,
    this.semanticsLabel,
    this.compact = false,
    super.key,
  });

  const AppActionTile.skeleton({
    this.compact = false,
    this.tint,
    super.key,
  }) : leading = const NinjaSkeleton(
         width: AppControlSize.iconTileCompact,
         height: AppControlSize.iconTileCompact,
         radius: AppRadius.iconTile,
       ),
       title = const AppSkeletonText(widthFactor: .8),
       subtitle = const AppSkeletonText(widthFactor: .85),
       trailing = const NinjaSkeleton(width: 15, height: 15, radius: 4),
       onTap = null,
       onLongPress = null,
       semanticsLabel = null;

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? tint;
  final String? semanticsLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final labels = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: AppText.headlineStrong.copyWith(color: colors.ink),
          maxLines: largeText ? null : 2,
          overflow: largeText ? TextOverflow.visible : TextOverflow.ellipsis,
          child: title,
        ),
        if (subtitle case final subtitleWidget?) ...[
          const SizedBox(height: AppSpacing.micro),
          DefaultTextStyle(
            style: AppText.cardDescription.copyWith(color: colors.muted),
            maxLines: largeText ? null : 1,
            overflow: largeText ? TextOverflow.visible : TextOverflow.ellipsis,
            child: subtitleWidget,
          ),
        ],
      ],
    );
    return AppPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      semanticsLabel: semanticsLabel,
      semanticsButton: onTap != null || onLongPress != null,
      child: AppGlassSurface(
        tone: AppGlassTone.subtle,
        tint: tint,
        borderRadius: AppRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: compact || largeText
            ? Row(
                children: [
                  leading,
                  const SizedBox(width: AppSpacing.gap),
                  Expanded(child: labels),
                  if (trailing case final trailingWidget?) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailingWidget,
                  ],
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppControlSize.touchTarget,
                    ),
                    child: Row(
                      children: [
                        leading,
                        const Spacer(),
                        ?trailing,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  labels,
                ],
              ),
      ),
    );
  }
}
