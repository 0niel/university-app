import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

part 'cover.dart';
part 'hero_action.dart';

class FeedHeroPost extends StatelessWidget {
  const FeedHeroPost({
    required this.title,
    required this.meta,
    super.key,
    this.imageUrl,
    this.badgeLabel,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.onTap,
    this.isLast = false,
  });

  final String title;
  final String meta;
  final String? imageUrl;
  final String? badgeLabel;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final badge = badgeLabel;
    final action = actionLabel;
    final secondary = secondaryActionLabel;
    final accessible = MediaQuery.textScalerOf(context).scale(1) >= 1.6;

    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(NinjaRadius.card),
      child: ColoredBox(
        color: colors.accentSoft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Cover(imageUrl: imageUrl),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (badge != null && badge.isNotEmpty) ...[
                    Text(
                      badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.microLabel.copyWith(
                        color: colors.onAccentSoftMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    title,
                    maxLines: accessible ? 5 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.title.copyWith(color: colors.onAccentSoft),
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      meta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.subtext.copyWith(
                        color: colors.onAccentSoftMuted,
                      ),
                    ),
                  ],
                  if (action != null || secondary != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        if (action != null)
                          Expanded(
                            child: _HeroAction(
                              label: action,
                              onPressed: onAction,
                              solid: true,
                            ),
                          ),
                        if (action != null && secondary != null)
                          const SizedBox(width: AppSpacing.sm),
                        if (secondary != null)
                          Expanded(
                            child: _HeroAction(
                              label: secondary,
                              onPressed: onSecondaryAction,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      final hasNestedActions = action != null || secondary != null;
      final pressable = AppPressable(onTap: onTap, child: content);
      content = Semantics(
        container: true,
        button: true,
        label: title,
        explicitChildNodes: hasNestedActions,
        excludeSemantics: !hasNestedActions,
        onTap: hasNestedActions ? null : onTap,
        child: pressable,
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        isLast ? 0 : AppSpacing.gap,
      ),
      child: content,
    );
  }
}
