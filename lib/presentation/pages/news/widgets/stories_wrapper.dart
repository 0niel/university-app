import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class StoriesWrapper extends StatelessWidget {
  const StoriesWrapper({
    required this.stories,
    required this.storyIndex,
  });

  final List<Story> stories;
  final int storyIndex;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismiss: () => Navigator.of(context).pop(),
      isFullScreen: false,
      direction: DismissDirection.vertical,
      child: Material(
        color: Colors.transparent,
        child: Hero(
          tag: stories[storyIndex].title,
          child: StoryPageView(
            initialPage: storyIndex,
            itemBuilder: (context, pageIndex, storyIndex) {
              final author = stories[pageIndex].author;
              final page = stories[pageIndex].pages[storyIndex];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: Colors.black),
                  ),
                  Positioned.fill(
                    child: Image.network(
                      page.media.formats.large.url,
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
                              image:
                                  NetworkImage(author.logo.formats.small.url),
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
                            Text(
                              page.title!,
                              style: DarkTextTheme.h4,
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                        stories[pageIndex].pages[storyIndex].actions.length,
                        (index) => PrimaryButton(
                          text: stories[pageIndex]
                              .pages[storyIndex]
                              .actions[index]
                              .title,
                          onClick: () async {
                            await launch(stories[pageIndex]
                                .pages[storyIndex]
                                .actions[index]
                                .url);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            pageLength: stories.length,
            storyLength: (int pageIndex) {
              return stories[pageIndex].pages.length;
            },
            onPageLimitReached: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
