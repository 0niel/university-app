import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/bloc/feed_bloc.dart';
import 'package:rtu_mirea_app/feed/view/story_viewer/story_viewer_page.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

export 'story_progress_bars.dart';
export 'story_slide.dart';
export 'story_viewer_page.dart';

Future<void> showStoryViewer(
  BuildContext context, {
  required String sourceId,
}) {
  final feedBloc = context.read<FeedBloc>();
  final categoriesBloc = context.read<CategoriesBloc>();
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      fullscreenDialog: true,
      opaque: false,
      barrierColor: AppColors.dark.canvas.withValues(alpha: 0),
      transitionDuration:
          MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context)
          ? Duration.zero
          : NinjaMotion.base,
      reverseTransitionDuration:
          MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context)
          ? Duration.zero
          : NinjaMotion.fast,
      pageBuilder: (_, _, _) => MultiBlocProvider(
        providers: [
          BlocProvider<FeedBloc>.value(value: feedBloc),
          BlocProvider<CategoriesBloc>.value(value: categoriesBloc),
        ],
        child: StoryViewerPage(
          sourceId: sourceId,
          onOpenArticle: (articleId) {
            if (!context.mounted) return;
            unawaited(ArticleRoute(articleId: articleId).push<void>(context));
          },
        ),
      ),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: NinjaMotion.enter),
        child: child,
      ),
    ),
  );
}
