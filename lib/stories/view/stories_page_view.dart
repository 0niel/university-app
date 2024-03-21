import 'package:analytics_repository/analytics_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:story/story.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class StoriesPageView extends StatefulWidget {
  const StoriesPageView({
    Key? key,
    required this.stories,
    required this.storyIndex,
  }) : super(key: key);

  final List<Story> stories;
  final int storyIndex;

  @override
  State<StoriesPageView> createState() => _StoriesPageViewState();
}

class _StoriesPageViewState extends State<StoriesPageView> {
  int _prevStoryIndex = -1;

  double computeMaxIntrinsicWidth(double height, double aspectRatio) {
    if (height.isFinite) {
      return height * aspectRatio;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => context.pop(),
      isFullScreen: false,
      direction: DismissiblePageDismissDirection.vertical,
      backgroundColor: Colors.black.withOpacity(0.8),
      child: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = computeMaxIntrinsicWidth(constraints.maxHeight, 9 / 16);

            return SizedBox(
              width: maxWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.transparent,
                  child: Hero(
                    tag: widget.stories[widget.storyIndex].title,
                    child: StoryPageView(
                      showShadow: true,
                      indicatorDuration: const Duration(seconds: 6, milliseconds: 500),
                      initialPage: widget.storyIndex,
                      itemBuilder: (context, pageIndex, storyIndex) {
                        if (pageIndex != _prevStoryIndex) {
                          _prevStoryIndex = pageIndex;
                          context.read<AnalyticsBloc>().add(
                                TrackAnalyticsEvent(
                                  ViewStory(
                                    storyTitle: widget.stories[pageIndex].title,
                                  ),
                                ),
                              );
                        }
                        final author = widget.stories[pageIndex].author;
                        final page = widget.stories[pageIndex].pages[storyIndex];
                        return _buildStoryPage(author, page);
                      },
                      pageLength: widget.stories.length,
                      storyLength: (int pageIndex) {
                        return widget.stories[pageIndex].pages.length;
                      },
                      onPageLimitReached: () => context.pop(),
                      gestureItemBuilder: (context, pageIndex, storyIndex) {
                        return _buildGestureItems(pageIndex, storyIndex);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoryPage(Author author, StoryPage page) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: page.media.formats != null
                ? ExtendedImage.network(
                    StrapiUtils.getLargestImageUrl(page.media.formats!),
                    fit: BoxFit.cover,
                    cache: true,
                  )
                : ExtendedImage.network(
                    page.media.url,
                    fit: BoxFit.cover,
                    cache: true,
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
                      image: author.logo.formats != null
                          ? NetworkImage(author.logo.formats!.small != null
                              ? author.logo.formats!.small!.url
                              : author.logo.formats!.thumbnail.url)
                          : NetworkImage(author.logo.url),
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
                  child: Text(
                    author.name,
                    style: AppTextStyle.bodyBold.copyWith(color: Colors.white),
                  ),
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
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Text(
                              page.title!,
                              style: AppTextStyle.h4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 16)
                        ],
                      ),
                    ),
                  if (page.text != null)
                    Text(
                      page.text!,
                      style: AppTextStyle.bodyBold,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureItems(int pageIndex, int storyIndex) {
    final height = MediaQuery.of(context).size.height;
    final contentHeigth = height * (9 / 16);
    final buttonSpaceHeight = (height - contentHeigth) / 2;

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 42),
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                icon: const Icon(Icons.close),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
        SizedBox(height: contentHeigth),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: buttonSpaceHeight),
          child: Column(
            children: List.generate(
              widget.stories[pageIndex].pages[storyIndex].actions.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PrimaryButton(
                  text: widget.stories[pageIndex].pages[storyIndex].actions[index].title,
                  onClick: () {
                    launchUrlString(
                      widget.stories[pageIndex].pages[storyIndex].actions[index].url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
