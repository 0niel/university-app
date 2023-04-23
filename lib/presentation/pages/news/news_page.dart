import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/app_settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'package:shimmer/shimmer.dart';
import 'widgets/news_item.dart';
import 'widgets/story_item.dart';
import 'widgets/tags_widgets.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _scrollController = ScrollController();

  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);

  void _filterNewsByTag(NewsBloc bloc, String tag) {
    bloc.add(
      NewsLoadEvent(
        refresh: true,
        isImportant: _tabValueNotifier.value == 1,
        tag: tag,
      ),
    );
  }

  /// Show iOS-style bottom sheet with tags. When user taps on tag, news will be filtered by it.
  /// If user taps on "все", news filter will be reset.
  void _showTagsModalWindow(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: AppTheme.colors.background03,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 4, bottom: 16, left: 24, right: 24),
            child: BlocConsumer<NewsBloc, NewsState>(
              listener: (context, state) =>
                  state.runtimeType != NewsLoaded ? context.router.pop() : null,
              buildWhen: (previous, current) => (current is NewsLoaded),
              builder: (context, state) {
                return Tags(
                  isClickable: true,
                  withIcon: false,
                  tags: ["все", ...(state as NewsLoaded).tags],
                  onClick: (tag) =>
                      _filterNewsByTag(context.read<NewsBloc>(), tag),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PrimaryTabButton(
                text: 'Новости',
                itemIndex: 0,
                notifier: _tabValueNotifier,
                onClick: () {
                  context.read<NewsBloc>().add(NewsLoadEvent(
                      refresh: true,
                      isImportant: _tabValueNotifier.value == 1));
                },
              ),
              PrimaryTabButton(
                text: 'Важное',
                itemIndex: 1,
                notifier: _tabValueNotifier,
                onClick: () {
                  context.read<NewsBloc>().add(
                        NewsLoadEvent(
                          refresh: true,
                          isImportant: _tabValueNotifier.value == 1,
                          tag: "все",
                        ),
                      );
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppSettingsButton(
              onClick: () => (context.read<NewsBloc>().state is NewsLoaded)
                  ? _showTagsModalWindow(context)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  List<Story> _getActualStories(List<Story> stories) {
    List<Story> actualStories = [];
    for (final story in stories) {
      if (DateTime.now().compareTo(story.stopShowDate) == -1) {
        actualStories.add(story);
      }
    }

    return actualStories;
  }

  Widget _buildFlexibleSpace(List<Story> stories) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int i) {
          if (DateTime.now().compareTo(stories[i].stopShowDate) == -1) {
            return StoryWidget(
              stories: stories,
              storyIndex: i,
            );
          }
          return Container();
        },
        separatorBuilder: (_, int i) => const SizedBox(width: 10),
        itemCount: stories.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        title: const Text("Новости"),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            BlocBuilder<StoriesBloc, StoriesState>(
              builder: (context, state) {
                if (state is StoriesInitial) {
                  context.read<StoriesBloc>().add(LoadStories());
                } else if (state is StoriesLoaded) {
                  final actualStories = _getActualStories(state.stories);
                  if (actualStories.isNotEmpty) {
                    return SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: 110,
                        actionsIconTheme: const IconThemeData(opacity: 0.0),
                        flexibleSpace: _buildFlexibleSpace(actualStories));
                  }
                }
                return const SliverAppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 0,
                  elevation: 0,
                  primary: false,
                  actionsIconTheme: IconThemeData(opacity: 0.0),
                );
              },
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            final innerScrollController = PrimaryScrollController.of(context);
            _setupScrollController(innerScrollController);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(NewsLoadEvent(
                    refresh: true, isImportant: _tabValueNotifier.value == 1));
                context.read<StoriesBloc>().add(LoadStories());
              },
              child: Column(children: [
                const SizedBox(height: 16),
                _buildTabButtons(context),
                BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    List<NewsItem> news = [];
                    bool isLoading = false;

                    if (state is NewsInitial) {
                      context.read<NewsBloc>().add(NewsLoadEvent(
                          isImportant: _tabValueNotifier.value == 1));
                    } else if (state is NewsLoaded) {
                      news = state.news;
                    } else if (state is NewsLoading && state.isFirstFetch) {
                      return Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    const _ShimmerNewsCardLoading(),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is NewsLoading) {
                      news = state.oldNews;
                      isLoading = true;
                    } else if (state is NewsLoadError) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Center(
                          child: Text(
                            'Произошла ошибка при загрузке новостей.',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.title,
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: news.length + (isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < news.length) {
                                  return NewsItemWidget(
                                      newsItem: news[index],
                                      onClickNewsTag: (tag) => _filterNewsByTag(
                                          context.read<NewsBloc>(), tag));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  void _setupScrollController(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context
            .read<NewsBloc>()
            .add(NewsLoadEvent(isImportant: _tabValueNotifier.value == 1));
      }
    });
  }
}

/// Widget with news card loading animation (shimmer effect).
/// Used for first-time loading.
class _ShimmerNewsCardLoading extends StatelessWidget {
  const _ShimmerNewsCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppTheme.colors.background02,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: AppTheme.colors.background01,
              highlightColor: AppTheme.colors.background02,
              child: Container(
                height: 175,
                decoration: BoxDecoration(
                  color: AppTheme.colors.background02,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppTheme.colors.background01,
                    highlightColor: AppTheme.colors.background02,
                    child: Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.background02,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: AppTheme.colors.background01,
                    highlightColor: AppTheme.colors.background02,
                    child: Container(
                      height: 18,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.background02,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
