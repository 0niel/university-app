import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesState = context.select((CategoriesBloc bloc) => bloc.state);
    final categories = categoriesState.categories ?? [];

    if (categoriesState.status == CategoriesStatus.initial ||
        categoriesState.status == CategoriesStatus.loading) {
      return _buildLoadingState(context);
    }

    if (categoriesState.status == CategoriesStatus.failure) {
      return _buildFailureState(context);
    }

    if (categories.isEmpty) {
      return _buildFailureState(context);
    }

    return FeedViewPopulated(categories: categories);
  }

  Widget _buildLoadingState(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      color: colors.background01,
      child: Column(
        children: [
          SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(color: colors.background01),
              child: Skeletonizer(
                enabled: true,
                effect: ShimmerEffect(
                  baseColor: colors.shimmerBase,
                  highlightColor: colors.shimmerHighlight,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(6, (index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: _CategoryTabSkeleton(),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(child: CategoryFeedLoaderItem()),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureState(BuildContext context) {
    return Center(
      key: Key('feedView_failure'),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: FailureScreen(
          title: 'Ошибка загрузки',
          description: 'Не удалось загрузить категории',
          icon: Icons.category_outlined,
          buttonText: 'Повторить',
          onButtonPressed: () {
            context.read<CategoriesBloc>().add(const CategoriesRequested());
          },
        ),
      ),
    );
  }
}

@visibleForTesting
class FeedViewPopulated extends StatefulWidget {
  const FeedViewPopulated({required this.categories, super.key});

  final List<Category> categories;

  @override
  State<FeedViewPopulated> createState() => _FeedViewPopulatedState();
}

class _FeedViewPopulatedState extends State<FeedViewPopulated>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;

  final Map<Category, ScrollController> _controllers =
      <Category, ScrollController>{};

  static const _categoryScrollToTopDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    )..addListener(_onTabChanged);

    for (final category in widget.categories) {
      _controllers[category] = ScrollController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<FeedBloc>().add(const FeedResumed());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controllers.forEach((_, controller) => controller.dispose());
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() => context.read<CategoriesBloc>().add(
    CategorySelected(category: widget.categories[_tabController.index]),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        final selectedCategory = state.selectedCategory;
        if (selectedCategory != null) {
          final selectedCategoryIndex = widget.categories.indexOf(
            selectedCategory,
          );
          if (selectedCategoryIndex != -1 &&
              selectedCategoryIndex != _tabController.index) {
            _tabController.animateTo(
              widget.categories.indexOf(selectedCategory),
            );
          }
        }
      },
      listenWhen:
          (previous, current) =>
              previous.selectedCategory != current.selectedCategory,
      child: Container(
        color: colors.background01,
        child: Column(
          children: [
            CategoriesTabBar(
              controller: _tabController,
              tabs:
                  widget.categories
                      .map(
                        (category) => CategoryTab(
                          categoryName: category.name,
                          onDoubleTap: () {
                            _controllers[category]?.animateTo(
                              0,
                              duration: _categoryScrollToTopDuration,
                              curve: Curves.easeOutCubic,
                            );
                          },
                        ),
                      )
                      .toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    widget.categories
                        .map(
                          (category) => CategoryFeed(
                            key: PageStorageKey(category),
                            category: category,
                            scrollController: _controllers[category],
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabSkeleton extends StatelessWidget {
  const _CategoryTabSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minWidth: 56),
      child: const SizedBox(height: 20, width: 64),
    );
  }
}
