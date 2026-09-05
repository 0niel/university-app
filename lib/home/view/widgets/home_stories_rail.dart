import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/feed/feed.dart';

class HomeStoriesRail extends StatelessWidget {
  const HomeStoriesRail({
    required this.sources,
    this.seenSourceIds = const {},
    this.onSourceOpened,
    this.loading = false,
    super.key,
  });

  final List<NewsSourceItem> sources;
  final Set<String> seenSourceIds;
  final ValueChanged<String>? onSourceOpened;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty && !loading) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: SizedBox(
        height: 66 + MediaQuery.textScalerOf(context).scale(13),
        child: sources.isEmpty
            ? ListView.separated(
                key: const Key('homeStoriesRail_skeleton'),
                scrollDirection: .horizontal,
                clipBehavior: .none,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, _) => const _HomeStorySkeletonItem(),
              )
            : ListView.separated(
                scrollDirection: .horizontal,
                clipBehavior: .none,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: sources.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final heroTag = (
                    'story-source',
                    context,
                    sources[index].sourceId,
                  );
                  return HomeStoryItem(
                    source: sources[index],
                    heroTag: heroTag,
                    highlighted: !seenSourceIds.contains(
                      sources[index].sourceId,
                    ),
                    onTap: () {
                      onSourceOpened?.call(sources[index].sourceId);
                      unawaited(
                        showStoryViewer(
                          context,
                          sourceId: sources[index].sourceId,
                          heroTag: heroTag,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _HomeStorySkeletonItem extends StatelessWidget {
  const _HomeStorySkeletonItem();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 64,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSkeleton.avatar(size: 60),
        SizedBox(height: 6),
        AppSkeleton(height: 10, widthFactor: .7),
      ],
    ),
  );
}

class HomeStoryItem extends StatelessWidget {
  const HomeStoryItem({
    required this.source,
    required this.highlighted,
    required this.onTap,
    this.heroTag,
    super.key,
  });

  final NewsSourceItem source;
  final bool highlighted;
  final VoidCallback onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = source.sourceName.isEmpty
        ? source.sourceId
        : source.sourceName;
    final avatar = source.avatarUrl;
    Widget thumbnail(Widget child) => heroTag == null
        ? child
        : HeroMode(
            enabled:
                !MediaQuery.disableAnimationsOf(context) &&
                !MediaQuery.accessibleNavigationOf(context),
            child: Hero(tag: heroTag!, child: child),
          );
    return AppPressable(
      onTap: onTap,
      semanticsLabel: name,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: .min,
          children: [
            thumbnail(
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: .circle,
                  color: highlighted ? colors.accent : colors.surface2,
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: colors.canvas,
                  ),
                  child: ClipOval(
                    child: avatar == null || avatar.isEmpty
                        ? ColoredBox(
                            color: colors.surface,
                            child: Center(
                              child: Text(
                                name.trim().split(RegExp(r'\s+')).length == 1
                                    ? name.characters
                                          .take(2)
                                          .toString()
                                          .toUpperCase()
                                    : AppAvatar.initialsOf(name),
                                style: AppText.sans(
                                  12,
                                  FontWeight.w800,
                                ).copyWith(color: colors.ink),
                              ),
                            ),
                          )
                        : Image.network(
                            avatar,
                            fit: .cover,
                            errorBuilder: (_, _, _) =>
                                const AppStripePlaceholder(
                                  shape: BoxShape.circle,
                                ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: AppText.sans(10.5, FontWeight.w600, height: 13 / 10.5)
                  .copyWith(
                    color: colors.muted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
