import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/news_card.dart';
import 'widgets/tag_badge.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabValueNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<NewsBloc>().add(NewsLoadEvent(refresh: true, isImportant: _tabValueNotifier.value == 1));
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: colors.background01,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: colors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              NewsPageAppBar(isDesktop: isDesktop),
              NewsFilterBar(tabValueNotifier: _tabValueNotifier, isDesktop: isDesktop),
              BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsInitial) {
                    context.read<NewsBloc>().add(const NewsLoadEvent(isImportant: false, refresh: true));
                    return NewsSkeletonLoader(context: context);
                  } else if (state is NewsLoading && state.isFirstFetch) {
                    return NewsSkeletonLoader(context: context);
                  } else if (state is NewsLoadError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: colors.deactive),
                            const SizedBox(height: 16),
                            Text(
                              'Ошибка загрузки новостей',
                              style: AppTextStyle.titleM.copyWith(color: colors.deactive),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed:
                                  () => context.read<NewsBloc>().add(
                                    const NewsLoadEvent(isImportant: false, refresh: true),
                                  ),
                              child: const Text('Повторить'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // For all other states (NewsLoaded, NewsLoading with !isFirstFetch)
                  final news = state is NewsLoaded ? state.news : <NewsItem>[];
                  final isLoading = state is NewsLoading;
                  final selectedTag = state is NewsLoaded ? state.selectedTag : null;

                  return NewsListView(
                    tabValueNotifier: _tabValueNotifier,
                    news: news,
                    isLoading: isLoading,
                    selectedTag: selectedTag,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsPageAppBar extends StatelessWidget {
  final bool isDesktop;

  const NewsPageAppBar({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SliverAppBar(
      pinned: true,
      expandedHeight: isDesktop ? 160 : 120,
      backgroundColor: colors.background01,
      elevation: 0,
      stretch: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 24, vertical: 16),
        title: Text(
          'Новости',
          style:
              isDesktop
                  ? AppTextStyle.h5.copyWith(color: colors.active)
                  : AppTextStyle.h6.copyWith(color: colors.active),
        ),
        background: Container(
          decoration: BoxDecoration(
            color: colors.background01,
            image: const DecorationImage(
              image: AssetImage('assets/images/news_pattern.png'),
              fit: BoxFit.cover,
              opacity: 0.05,
            ),
          ),
        ),
      ),
    );
  }
}

class NewsFilterBar extends StatelessWidget {
  final ValueNotifier<int> tabValueNotifier;
  final bool isDesktop;

  const NewsFilterBar({super.key, required this.tabValueNotifier, required this.isDesktop});

  void _showTagsModalWindow(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.background02,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => NewsTagsModal(tabValueNotifier: tabValueNotifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: Container(
          color: colors.background01,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CategoryAnimatedTabBar(
                  tabs: const ['Все новости', 'Важное'],
                  selectedIndex: tabValueNotifier.value,
                  onTap: (index) {
                    tabValueNotifier.value = index;
                    context.read<NewsBloc>().add(NewsLoadEvent(refresh: true, isImportant: index == 1));
                  },
                  height: 40,
                  scrollable: false,
                ),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => (context.read<NewsBloc>().state is NewsLoaded) ? _showTagsModalWindow(context) : null,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Icon(Icons.filter_list_rounded, color: colors.active, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsTagsModal extends StatelessWidget {
  final ValueNotifier<int> tabValueNotifier;

  const NewsTagsModal({super.key, required this.tabValueNotifier});

  Color _getTagColor(int index, BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorList = [
      colors.colorful01,
      colors.colorful02,
      colors.colorful03,
      colors.colorful04,
      colors.colorful05,
      colors.colorful06,
      colors.colorful07,
    ];
    return colorList[index % colorList.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: BlocBuilder<NewsBloc, NewsState>(
          buildWhen: (prev, curr) => curr is NewsLoaded,
          builder: (context, state) {
            if (state is! NewsLoaded) return const SizedBox.shrink();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Категории', style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w700)),
                    TextButton.icon(
                      onPressed:
                          () => context.read<NewsBloc>().add(
                            NewsLoadEvent(refresh: true, isImportant: tabValueNotifier.value == 1, tag: "все"),
                          ),
                      icon: Icon(Icons.refresh, size: 16, color: colors.primary),
                      label: Text(
                        'Сбросить',
                        style: AppTextStyle.captionL.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: List.generate(
                    state.tags.length,
                    (i) => TagBadge(
                      tag: state.tags[i],
                      isSelected: state.selectedTag == state.tags[i],
                      color: _getTagColor(i, context),
                      onPressed:
                          () => context.read<NewsBloc>().add(
                            NewsLoadEvent(
                              refresh: true,
                              isImportant: tabValueNotifier.value == 1,
                              tag: state.selectedTag == state.tags[i] ? "все" : state.tags[i],
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NewsSkeletonLoader extends StatelessWidget {
  final BuildContext context;

  const NewsSkeletonLoader({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).extension<AppColors>()!;
    int columnCount;

    if (screenWidth < 600) {
      columnCount = 1;
    } else if (screenWidth < 900) {
      columnCount = 2;
    } else if (screenWidth < 1200) {
      columnCount = 2;
    } else {
      columnCount = 4;
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Skeletonizer(enabled: true, child: const NewsCardSkeleton()),
          childCount: columnCount * 2,
        ),
      ),
    );
  }
}

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust image height based on screen size for more responsive design
    final imageHeight = screenWidth < 600 ? 160.0 : 180.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image skeleton
          AspectRatio(aspectRatio: 16 / 9, child: Container(width: double.infinity, color: colors.background03)),

          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date badge skeleton
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "01 янв. 2023 г.",
                    style: AppTextStyle.captionS.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),

                // Title skeleton - multiple lines for realistic appearance
                Text(
                  "Заголовок новости для скелетон загрузки текстом подлиннее",
                  style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600, height: 1.2),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  "Продолжение заголовка новости",
                  style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600, height: 1.2),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),

                // Tags skeleton - using actual tag layout
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: colors.colorful01, width: 1.5),
                      ),
                      child: Text(
                        "Тег",
                        style: AppTextStyle.chip.copyWith(color: colors.colorful01, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: colors.colorful02, width: 1.5),
                      ),
                      child: Text(
                        "Категория",
                        style: AppTextStyle.chip.copyWith(color: colors.colorful02, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsListView extends StatelessWidget {
  final ValueNotifier<int> tabValueNotifier;
  final List<NewsItem> news;
  final bool isLoading;
  final String? selectedTag;

  const NewsListView({
    super.key,
    required this.tabValueNotifier,
    required this.news,
    required this.isLoading,
    this.selectedTag,
  });

  Future<void> _fetchMoreData(BuildContext context) async {
    if (!isLoading) {
      context.read<NewsBloc>().add(NewsLoadEvent(isImportant: tabValueNotifier.value == 1, tag: selectedTag));
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (news.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyNewsView(selectedTag: selectedTag, tabValueNotifier: tabValueNotifier),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < news.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NewsCard(
              key: ValueKey('news_${news[index].title}'),
              newsItem: news[index],
              onClickNewsTag:
                  (tag) => context.read<NewsBloc>().add(
                    NewsLoadEvent(refresh: true, isImportant: tabValueNotifier.value == 1, tag: tag),
                  ),
            ),
          );
        }
        if (isLoading && index == news.length) {
          _fetchMoreData(context);
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return null;
      }, childCount: news.length + (isLoading ? 1 : 0)),
    );
  }
}

class EmptyNewsView extends StatelessWidget {
  final String? selectedTag;
  final ValueNotifier<int> tabValueNotifier;

  const EmptyNewsView({super.key, required this.selectedTag, required this.tabValueNotifier});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper, size: 64, color: colors.deactive),
          const SizedBox(height: 16),
          Text('Новости не найдены', style: AppTextStyle.titleM.copyWith(color: colors.deactive)),
          if (selectedTag != null && selectedTag != "все")
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  context.read<NewsBloc>().add(
                    NewsLoadEvent(refresh: true, isImportant: tabValueNotifier.value == 1, tag: "все"),
                  );
                },
                child: const Text('Сбросить фильтр'),
              ),
            ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
