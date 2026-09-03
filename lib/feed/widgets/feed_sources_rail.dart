import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class FeedSourceRailItem {
  const FeedSourceRailItem({
    required this.id,
    required this.name,
    required this.abbr,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String abbr;
  final String? avatarUrl;
}

class FeedSourcesRail extends StatelessWidget {
  const FeedSourcesRail({
    required this.items,
    required this.selectedId,
    required this.onSelected,
    super.key,
    this.semanticsLabel,
  });

  final List<FeedSourceRailItem> items;
  final String selectedId;
  final ValueChanged<FeedSourceRailItem> onSelected;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final height = 63 + 14 * textScale.clamp(1.0, 2.0);
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          itemCount: items.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: AppSpacing.sectionGap),
          itemBuilder: (context, index) {
            final item = items[index];
            return _SourceCircle(
              item: item,
              selected: item.id == selectedId,
              onTap: () => onSelected(item),
            );
          },
        ),
      ),
    );
  }
}

class _SourceCircle extends StatelessWidget {
  const _SourceCircle({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FeedSourceRailItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final avatarUrl = item.avatarUrl;
    final fallback = Center(
      child: Text(
        item.abbr,
        style: AppText.sans(13, FontWeight.w800, height: 1).copyWith(
          color: selected ? colors.onAccent : colors.ink,
        ),
      ),
    );
    return AppPressState(
      onTap: onTap,
      semanticsLabel: item.name,
      semanticsButton: true,
      semanticsSelected: selected,
      builder: (context, {required pressed}) => SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: -4,
                    top: -4,
                    right: -4,
                    bottom: -4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: selected ? colors.accent : colors.canvas,
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: NinjaMotion.base,
                    curve: NinjaMotion.enter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? colors.accent
                          : pressed
                          ? colors.surface2
                          : colors.surface,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? fallback
                        : CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => fallback,
                            errorWidget: (_, _, _) => fallback,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.sans(
                11,
                FontWeight.w600,
                height: 14 / 11,
              ).copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
