import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_thumbnail.dart';

class FeedPostRow extends StatelessWidget {
  const FeedPostRow({
    required this.title,
    required this.meta,
    super.key,
    this.imageUrl,
    this.onTap,
    this.isLast = false,
  });

  final String title;
  final String meta;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final accessible = MediaQuery.textScalerOf(context).scale(1) >= 1.6;

    Widget card = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          FeedThumbnail(imageUrl: imageUrl, size: accessible ? 64 : 72),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: accessible ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.body.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    meta,
                    maxLines: accessible ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.xs),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.chevron,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      card = AppPressable(onTap: onTap, semanticsLabel: title, child: card);
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        isLast ? 0 : AppSpacing.gap,
      ),
      child: card,
    );
  }
}
