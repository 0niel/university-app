import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesState = context.select<CategoriesBloc, CategoriesState>(
      (bloc) => bloc.state,
    );
    return NinjaStateSwitcher(child: _body(context, categoriesState));
  }

  Widget _body(BuildContext context, CategoriesState categoriesState) {
    final categories = categoriesState.categories ?? [];
    if (categories.isEmpty &&
        (categoriesState.status == .initial ||
            categoriesState.status == .loading)) {
      return _buildLoadingState(context);
    }
    if (categories.isEmpty) return _buildFailureState(context);
    return FeedViewPopulated(
      key: const ValueKey('feedView_populated'),
      categories: categories,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return NinjaSkeletonGroup(
      key: const ValueKey('feedView_loading'),
      semanticsLabel: context.l10n.loadingContent,
      child: ColoredBox(
        color: context.ninja.canvas,
        child: const Column(
          children: [
            CategoriesTabBar(isLoading: true, tabs: []),
            Expanded(
              child: SingleChildScrollView(child: CategoryFeedLoaderItem()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailureState(BuildContext context) {
    return ColoredBox(
      key: const Key('feedView_failure'),
      color: context.ninja.canvas,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
          ),
          child: NinjaErrorState(
            title: context.l10n.loadingError,
            message: context.l10n.feedLoadCategoriesError,
            retryLabel: context.l10n.retry,
            onRetry: () {
              context.read<CategoriesBloc>().add(const CategoriesRequested());
            },
          ),
        ),
      ),
    );
  }
}
