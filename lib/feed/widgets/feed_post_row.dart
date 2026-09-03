import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';

class FeedPostRow extends StatelessWidget {
  const FeedPostRow({
    required this.title,
    required this.meta,
    super.key,
    this.source,
    this.imageUrl,
    this.onTap,
    this.isLast = false,
  });

  final String title;
  final String meta;
  final String? source;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final source = this.source;
    final hasSource = source != null && source.isNotEmpty;
    final metaStyle = AppText.captionStrong.copyWith(color: colors.muted);
    return AppPressState(
      onTap: onTap,
      enabled: onTap != null,
      semanticsLabel: title,
      semanticsButton: onTap != null,
      builder: (context, {required pressed}) => ColoredBox(
        color: pressed ? colors.canvas : colors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sectionGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          if (hasSource)
                            TextSpan(
                              text: source,
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
                    const SizedBox(height: 5),
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headline.copyWith(
                        color: colors.ink,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sectionGap),
              FeedImage(
                imageUrl: imageUrl,
                radius: AppRadius.banner,
                width: 72,
                height: 72,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
