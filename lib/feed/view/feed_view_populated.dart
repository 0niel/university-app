import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';

@visibleForTesting
class FeedViewPopulated extends StatefulWidget {
  const FeedViewPopulated({required this.categories, super.key});

  final List<Category> categories;

  @override
  State<FeedViewPopulated> createState() => _FeedViewPopulatedState();
}

class _FeedViewPopulatedState extends State<FeedViewPopulated>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;
  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: NinjaMotion.fast,
    value: 1,
  );
  late final CurvedAnimation _fade = CurvedAnimation(
    parent: _fadeController,
    curve: NinjaMotion.enter,
  );
  late int _selectedIndex;

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
      animationDuration: Duration.zero,
    )..addListener(_onTabChanged);
    _selectedIndex = _tabController.index;

    for (final category in widget.categories) {
      _controllers[category] = ScrollController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
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
    _fade.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final index = _tabController.index;
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    if (_reduceMotion(context)) {
      _fadeController.value = 1;
    } else {
      unawaited(_fadeController.forward(from: 0));
    }
    final category = widget.categories.elementAtOrNull(index);
    if (category == null) return;
    context.read<CategoriesBloc>().add(CategorySelected(category: category));
  }

  bool _reduceMotion(BuildContext context) =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
      (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        final selectedCategory = state.selectedCategory;
        if (selectedCategory != null) {
          final selectedCategoryIndex = widget.categories.indexOf(
            selectedCategory,
          );
          if (selectedCategoryIndex != -1 &&
              selectedCategoryIndex != _tabController.index) {
            _tabController.index = selectedCategoryIndex;
          }
        }
      },
      listenWhen: (previous, current) =>
          previous.selectedCategory != current.selectedCategory,
      child: ColoredBox(
        color: context.ninja.canvas,
        child: Column(
          children: [
            CategoriesTabBar(
              controller: _tabController,
              tabs: widget.categories
                  .map(
                    (category) => CategoryTabData(
                      categoryName: category.name,
                      onDoubleTap: () {
                        final controller = _controllers[category];
                        if (controller != null && controller.hasClients) {
                          unawaited(HapticFeedback.lightImpact());
                          if (reduceMotion) {
                            controller.jumpTo(0);
                          } else {
                            unawaited(
                              controller.animateTo(
                                0,
                                duration: _categoryScrollToTopDuration,
                                curve: Curves.easeOutCubic,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _fade,
                builder: (context, child) => Opacity(
                  opacity: 0.6 + 0.4 * _fade.value,
                  child: FractionalTranslation(
                    translation: Offset(0, (1 - _fade.value) * 0.01),
                    child: child,
                  ),
                ),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: widget.categories
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
            ),
          ],
        ),
      ),
    );
  }
}
