import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';

class FeedHeroPost extends StatelessWidget {
  const FeedHeroPost({
    required this.title,
    required this.meta,
    super.key,
    this.source,
    this.lead,
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
  final String? source;
  final String? lead;
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
    final colors = context.colors;
    final sourceLabel = source ?? badgeLabel;
    final hasSource = sourceLabel != null && sourceLabel.isNotEmpty;
    final lead = this.lead;
    final action = actionLabel;
    final secondary = secondaryActionLabel;
    final metaStyle = AppText.captionStrong.copyWith(color: colors.muted);

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? AppSpacing.zero : AppSpacing.gap,
      ),
      child: AppCard(
        radius: AppRadius.hero,
        padding: EdgeInsets.zero,
        onTap: onTap,
        semanticsLabel: title,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.hero),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FeedImage(
                imageUrl: imageUrl,
                radius: AppRadius.none,
                height: 190,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.fieldGap,
                  AppSpacing.lg,
                  AppSpacing.fieldGap,
                  AppSpacing.fieldGap,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          if (hasSource)
                            TextSpan(
                              text: sourceLabel,
                              style: metaStyle.copyWith(color: colors.accent),
                            ),
                          if (hasSource && meta.isNotEmpty)
                            const TextSpan(text: ' · '),
                          TextSpan(text: meta),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: metaStyle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppBalancedText(
                      title,
                      style: AppText.section.copyWith(
                        color: colors.ink,
                        height: 1.2,
                      ),
                    ),
                    if (lead != null && lead.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        lead,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                          13.5,
                          FontWeight.w400,
                          height: 1.45,
                        ).copyWith(color: colors.muted),
                      ),
                    ],
                    if (action != null || secondary != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          if (action != null)
                            Expanded(
                              child: AppButton.primary(
                                label: action,
                                onPressed: onAction,
                                size: AppButtonSize.small,
                                expanded: true,
                              ),
                            ),
                          if (action != null && secondary != null)
                            const SizedBox(width: AppSpacing.sm),
                          if (secondary != null)
                            Expanded(
                              child: AppButton.secondary(
                                label: secondary,
                                onPressed: onSecondaryAction,
                                size: AppButtonSize.small,
                                expanded: true,
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
      ),
    );
  }
}
