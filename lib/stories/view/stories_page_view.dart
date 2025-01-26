import 'package:analytics_repository/analytics_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:app_ui/app_ui.dart';
import 'package:story/story.dart';

class StoriesPageView extends StatefulWidget {
  const StoriesPageView({
    super.key,
    required this.stories,
    required this.storyIndex,
  });

  final List<Story> stories;
  final int storyIndex;

  @override
  State<StoriesPageView> createState() => _StoriesPageViewState();
}

class _StoriesPageViewState extends State<StoriesPageView> {
  int _prevStoryIndex = -1;

  late int _currentPageIndex;
  late int _currentStoryIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.storyIndex;
    _currentStoryIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      isFullScreen: true,
      direction: DismissiblePageDismissDirection.vertical,
      backgroundColor: Colors.black.withOpacity(0.8),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
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

                        if (_currentPageIndex != pageIndex || _currentStoryIndex != storyIndex) {
                          setState(() {
                            _currentPageIndex = pageIndex;
                            _currentStoryIndex = storyIndex;
                          });
                        }

                        final author = widget.stories[pageIndex].author;
                        final page = widget.stories[pageIndex].pages[storyIndex];
                        return _buildStoryPage(author, page);
                      },
                      pageLength: widget.stories.length,
                      storyLength: (int pageIndex) {
                        return widget.stories[pageIndex].pages.length;
                      },
                      onPageLimitReached: () => Navigator.of(context).pop(),
                      gestureItemBuilder: (context, pageIndex, storyIndex) {
                        return _buildGestureItems(pageIndex, storyIndex);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPage(Author author, StoryPage page) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
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
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top: 42,
          left: 16,
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: author.logo.formats != null
                        ? NetworkImage(
                            author.logo.formats!.small?.url ?? author.logo.formats!.thumbnail.url,
                          )
                        : NetworkImage(author.logo.url),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                author.name,
                style: AppTextStyle.bodyBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 80,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (page.title != null)
                Text(
                  page.title!,
                  style: AppTextStyle.h4.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (page.text != null) ...[
                const SizedBox(height: 8),
                Text(
                  page.text!,
                  style: AppTextStyle.bodyBold.copyWith(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final pageIndex = _currentPageIndex;
    final storyIndex = _currentStoryIndex;

    if (pageIndex < 0 ||
        pageIndex >= widget.stories.length ||
        storyIndex < 0 ||
        storyIndex >= widget.stories[pageIndex].pages.length) {
      return const SizedBox.shrink();
    }

    final actions = widget.stories[pageIndex].pages[storyIndex].actions;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: PrimaryButton(
            text: action.title,
            onClick: () {
              launchUrlString(
                action.url,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGestureItems(int pageIndex, int storyIndex) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 32, right: 16),
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
