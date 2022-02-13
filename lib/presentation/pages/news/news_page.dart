import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/app_settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'widgets/news_item.dart';
import 'widgets/story_item.dart';
import 'widgets/tags_widgets.dart';

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

  void _showTagsModalWindow(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: DarkThemeColors.background03,
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
                  context.read<NewsBloc>().add(NewsLoadEvent(
                      refresh: true,
                      isImportant: _tabValueNotifier.value == 1,
                      tag: "все"));
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child:
                AppSettingsButton(onClick: () => _showTagsModalWindow(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Новости"),
        backgroundColor: DarkThemeColors.background01,
      ),
      backgroundColor: DarkThemeColors.background01,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 110,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              flexibleSpace: BlocBuilder<StoriesBloc, StoriesState>(
                  builder: (context, state) {
                if (state is StoriesInitial) {
                  context.read<StoriesBloc>().add(LoadStories());
                } else if (state is StoriesLoading) {
                  return Container();
                } else if (state is StoriesLoaded) {
                  for (final story in state.stories) {
                    if (DateTime.now().compareTo(story.stopShowDate) == -1) {
                      return SizedBox(
                        height: 120,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, int i) {
                              if (DateTime.now().compareTo(
                                      state.stories[i].stopShowDate) ==
                                  -1) {
                                return StoryWidget(
                                  stories: state.stories,
                                  storyIndex: i,
                                );
                              }
                              return Container();
                            },
                            separatorBuilder: (_, int i) =>
                                const SizedBox(width: 10),
                            itemCount: state.stories.length),
                      );
                    }
                  }
                }
                return Container();
              }),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            final innerScrollController = PrimaryScrollController.of(context);
            _setupScrollController(innerScrollController!);

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
                      return const Center(
                        child: CircularProgressIndicator(),
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
                            style: DarkTextTheme.title,
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
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          context
              .read<NewsBloc>()
              .add(NewsLoadEvent(isImportant: _tabValueNotifier.value == 1));
        }
      }
    });
  }
}
