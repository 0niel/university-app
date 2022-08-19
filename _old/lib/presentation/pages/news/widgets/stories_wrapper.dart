import 'package:auto_route/auto_route.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';

class StoriesWrapper extends StatefulWidget {
  const StoriesWrapper({
    Key? key,
    required this.stories,
    required this.storyIndex,
  }) : super(key: key);

  final List<Story> stories;
  final int storyIndex;

  @override
  State<StoriesWrapper> createState() => _StoriesWrapperState();
}

class _StoriesWrapperState extends State<StoriesWrapper> {
  // In order not to send the same request to analytics several times
  int _prevStoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismiss: () => context.router.pop(),
      isFullScreen: false,
      direction: DismissDirection.vertical,
      child: Material(
        color: Colors.transparent,
        child: Hero(
          tag: widget.stories[widget.storyIndex].title,
          child: StoryPageView(
            indicatorDuration: const Duration(seconds: 6, milliseconds: 500),
            initialPage: widget.storyIndex,
            itemBuilder: (context, pageIndex, storyIndex) {
              if (pageIndex != _prevStoryIndex) {
                _prevStoryIndex = pageIndex;
                FirebaseAnalytics.instance
                    .logEvent(name: 'view_story', parameters: {
                  'story_title': widget.stories[pageIndex].title,
                });
              }
              final author = widget.stories[pageIndex].author;
              final page = widget.stories[pageIndex].pages[storyIndex];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: Colors.black),
                  ),
                  Positioned.fill(
                    child: Image.network(
                      MediaQuery.of(context).size.width > 580
                          ? StrapiUtils.getLargestImageUrl(page.media.formats)
                          : StrapiUtils.getMediumImageUrl(page.media.formats),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 44, left: 8),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  author.logo.formats.small != null
                                      ? author.logo.formats.small!.url
                                      : author.logo.formats.thumbnail.url),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child:
                              Text(author.name, style: DarkTextTheme.bodyBold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 105,
                    left: 24,
                    right: 24,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (page.title != null)
                            Column(
                              children: [
                                Text(
                                  page.title!,
                                  style: DarkTextTheme.h4,
                                ),
                                const SizedBox(height: 16)
                              ],
                            ),
                          if (page.text != null)
                            Text(
                              page.text!,
                              style: DarkTextTheme.bodyBold,
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            gestureItemBuilder: (context, pageIndex, storyIndex) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          icon: const Icon(Icons.close),
                          onPressed: () => context.router.pop(),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: List.generate(
                        widget.stories[pageIndex].pages[storyIndex].actions
                            .length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PrimaryButton(
                            text: widget.stories[pageIndex].pages[storyIndex]
                                .actions[index].title,
                            onClick: () async {
                              await launch(widget.stories[pageIndex]
                                  .pages[storyIndex].actions[index].url);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            pageLength: widget.stories.length,
            storyLength: (int pageIndex) {
              return widget.stories[pageIndex].pages.length;
            },
            onPageLimitReached: () => context.router.pop(),
          ),
        ),
      ),
    );
  }
}
