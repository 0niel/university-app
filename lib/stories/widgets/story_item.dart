import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({Key? key, required this.stories, required this.storyIndex}) : super(key: key);

  final int storyIndex;
  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/story/$storyIndex', extra: stories);
      },
      child: Hero(
        tag: stories[storyIndex].title,
        child: Container(
          height: 80,
          width: 68,
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: stories[storyIndex].preview.formats != null
                  ? CachedNetworkImageProvider(stories[storyIndex].preview.formats!.small != null
                      ? stories[storyIndex].preview.formats!.small!.url
                      : stories[storyIndex].preview.formats!.thumbnail.url)
                  : CachedNetworkImageProvider(stories[storyIndex].preview.url),
              colorFilter:
                  ColorFilter.mode(AppTheme.colorsOf(context).background02.withOpacity(0.15), BlendMode.dstOut),
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              stories[storyIndex].title,
              style: AppTextStyle.chip.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
