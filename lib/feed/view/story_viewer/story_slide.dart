import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_layout.dart';

class StorySlide extends StatelessWidget {
  const StorySlide({
    required this.title,
    required this.meta,
    required this.readLabel,
    required this.onRead,
    super.key,
    this.lead,
    this.imageUrl,
    this.onMediaReady,
    this.imageHeroTag,
  });

  final String title;
  final String meta;
  final String? lead;
  final String? imageUrl;
  final String readLabel;
  final VoidCallback onRead;
  final VoidCallback? onMediaReady;
  final Object? imageHeroTag;

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    final white = context.colors.white;
    final lead = this.lead;
    final imageUrl = this.imageUrl;
    Widget image(Widget child) => imageHeroTag == null
        ? child
        : HeroMode(
            enabled:
                !MediaQuery.disableAnimationsOf(context) &&
                !MediaQuery.accessibleNavigationOf(context),
            child: Hero(tag: imageHeroTag!, child: child),
          );
    return Stack(
      fit: StackFit.expand,
      children: [
        const IgnorePointer(child: StoryBackdrop()),
        if (imageUrl != null && imageUrl.isNotEmpty)
          IgnorePointer(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                dark.canvas.withValues(alpha: .35),
                BlendMode.darken,
              ),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        if (imageUrl != null && imageUrl.isNotEmpty)
          IgnorePointer(
            child: image(
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                imageBuilder: (context, provider) {
                  onMediaReady?.call();
                  return Image(image: provider, fit: BoxFit.contain);
                },
                placeholder: (_, _) => const SizedBox.shrink(),
                errorWidget: (_, _, _) {
                  onMediaReady?.call();
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        IgnorePointer(
          child: DecoratedBox(
            key: const Key('storyViewer_scrim'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, .3, .55, 1],
                colors: [
                  dark.canvas.withValues(alpha: 140 / 255),
                  dark.canvas.withValues(alpha: 0),
                  dark.canvas.withValues(alpha: 0),
                  dark.canvas.withValues(alpha: 191 / 255),
                ],
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.zero,
                AppSpacing.screen,
                AppSpacing.xxlg,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: math.max(
                    0,
                    constraints.maxHeight -
                        math.max(
                          StoryLayout.contentTopClearance,
                          MediaQuery.paddingOf(context).top +
                              StoryLayout.safeHeaderClearance,
                        ) -
                        StoryLayout.bottomInset,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        key: const Key('storyViewer_content'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: white.withValues(alpha: .15),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xsm,
                                ),
                                child: Text(
                                  meta,
                                  style: AppText.captionBold.copyWith(
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppBalancedText(
                              title,
                              style: AppText.displayCompact.copyWith(
                                color: white,
                              ),
                            ),
                            if (lead != null && lead.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                lead,
                                style: AppText.sans(
                                  14.5,
                                  FontWeight.w400,
                                  height: 1.45,
                                ).copyWith(color: white.withValues(alpha: .8)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.fieldGap),
                    AppButton.primary(
                      key: const Key('storyViewer_read'),
                      label: readLabel,
                      onPressed: onRead,
                      size: AppButtonSize.large,
                      expanded: true,
                      backgroundColor: white,
                      foregroundColor: dark.canvas,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StoryBackdrop extends StatelessWidget {
  const StoryBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    return AppStripePlaceholder(
      base: dark.surface2,
      stripe: dark.surface,
      stripeWidth: StoryLayout.stripeWidth,
    );
  }
}
