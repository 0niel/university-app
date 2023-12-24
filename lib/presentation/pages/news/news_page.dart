import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/app_settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/page_with_theme_consumer.dart';
import 'package:shimmer/shimmer.dart';
import 'widgets/news_card.dart';
import 'widgets/tag_badge.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class NewsPage extends PageWithThemeConsumer {
  NewsPage({super.key});

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
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: AppTheme.colors.background02,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Container(
          height: 420 < MediaQuery.of(context).size.height * 0.6
              ? 420
              : MediaQuery.of(context).size.height * 0.6,
          padding:
              const EdgeInsets.only(top: 4, bottom: 16, left: 24, right: 24),
          child: BlocConsumer<NewsBloc, NewsState>(
            listener: (context, state) =>
                state.runtimeType != NewsLoaded ? context.pop() : null,
            buildWhen: (previous, current) => (current is NewsLoaded),
            builder: (context, state) {
              final loadedState = state as NewsLoaded;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagBadge(
                    tag: "все",
                    onPressed: () =>
                        _filterNewsByTag(context.read<NewsBloc>(), "все"),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          loadedState.tags.length,
                          (index) {
                            if (loadedState.selectedTag ==
                                loadedState.tags[index]) {
                              return TagBadge(
                                tag: loadedState.tags[index],
                                color: AppTheme.colors.colorful04,
                                onPressed: () => _filterNewsByTag(
                                    context.read<NewsBloc>(), "все"),
                              );
                            }
                            return TagBadge(
                              tag: loadedState.tags[index],
                              onPressed: () => _filterNewsByTag(
                                  context.read<NewsBloc>(),
                                  loadedState.tags[index]),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
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

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        title: const Text("Новости"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          List<NewsItem> news = [];
          bool isLoading = false;

          return Column(
            children: [
              const SizedBox(height: 16),
              _buildTabButtons(context),
              Expanded(
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsInitial) {
                      context.read<NewsBloc>().add(NewsLoadEvent(
                          isImportant: _tabValueNotifier.value == 1,
                          refresh: true));
                    } else if (state is NewsLoaded) {
                      news = state.news;
                    } else if (state is NewsLoading && state.isFirstFetch) {
                      return Column(
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
                      );
                    } else if (state is NewsLoading) {
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
                    return _NewsPageView(
                      tabValueNotifier: _tabValueNotifier,
                      news: news,
                      isLoading: isLoading,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NewsPageView extends StatefulWidget {
  const _NewsPageView({
    Key? key,
    required this.tabValueNotifier,
    required this.news,
    required this.isLoading,
  }) : super(key: key);

  final ValueNotifier<int> tabValueNotifier;
  final List<NewsItem> news;
  final bool isLoading;

  @override
  _NewsPageViewState createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<_NewsPageView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (context.read<NewsBloc>().state is! NewsLoading) {
        context.read<NewsBloc>().add(NewsLoadEvent(
              isImportant: widget.tabValueNotifier.value == 1,
            ));
      }
    }
  }

  int _getColumnCount(double screenWidth) {
    if (screenWidth < 900) {
      return 1;
    } else if (screenWidth < 1200) {
      return 3;
    } else {
      return 4;
    }
  }

  double _computeWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Compute view size for desktop with sidebar
    final viewSize = screenWidth > 600 ? screenWidth - 240 : screenWidth;

    final columnCount = _getColumnCount(viewSize);

    return (viewSize - (columnCount - 1) * 10) / columnCount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 0,
        runSpacing: 0,
        children: [
          const SizedBox(
            width: double.infinity,
            height: 16,
          ),
          for (var index = 0; index < widget.news.length; index++)
            SizedBox(
              width: _computeWidth(context),
              child: NewsCard(
                  newsItem: widget.news[index],
                  onClickNewsTag: (tag) => context.read<NewsBloc>().add(
                        NewsLoadEvent(
                          refresh: true,
                          isImportant: widget.tabValueNotifier.value == 1,
                          tag: tag,
                        ),
                      )),
            ),
          if (widget.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
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
