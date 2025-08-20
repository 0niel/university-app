import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:share_launcher/share_launcher.dart';

/// The supported behaviors for interstitial ad.
enum InterstitialAdBehavior {
  /// Displays the ad when opening the article.
  onOpen,

  /// Displays the ad when closing the article.
  onClose,
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({required this.id, required this.isVideoArticle, required this.interstitialAdBehavior, super.key});

  /// The id of the requested article.
  final String id;

  /// Whether the requested article is a video article.
  final bool isVideoArticle;

  /// Indicates when the interstitial ad will be displayed.
  /// Default to [InterstitialAdBehavior.onOpen]
  final InterstitialAdBehavior interstitialAdBehavior;

  static Route<void> route({
    required String id,
    bool isVideoArticle = false,
    InterstitialAdBehavior interstitialAdBehavior = InterstitialAdBehavior.onOpen,
  }) => MaterialPageRoute<void>(
    builder: (_) => ArticlePage(id: id, isVideoArticle: isVideoArticle, interstitialAdBehavior: interstitialAdBehavior),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleBloc>(
      create:
          (_) => ArticleBloc(
            articleId: id,
            shareLauncher: const ShareLauncher(),
            articleRepository: context.read<ArticleRepository>(),
          )..add(const ArticleRequested()),
      child: ArticleView(isVideoArticle: isVideoArticle, interstitialAdBehavior: interstitialAdBehavior),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({required this.isVideoArticle, required this.interstitialAdBehavior, super.key});

  final bool isVideoArticle;
  final InterstitialAdBehavior interstitialAdBehavior;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final backgroundColor = isVideoArticle ? colors.background01 : colors.background02;
    final foregroundColor = isVideoArticle ? colors.white : colors.active;
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);

    return PopScope(
      onPopInvokedWithResult: (_, __) => _onPop(context),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: isVideoArticle ? Brightness.light : Brightness.dark,
            statusBarBrightness: isVideoArticle ? Brightness.dark : Brightness.light,
          ),
          leading:
              isVideoArticle
                  ? AppBackButton.light(onPressed: Navigator.of(context).pop)
                  : AppBackButton(onPressed: Navigator.of(context).pop),
          actions: [
            if (uri != null && uri.toString().isNotEmpty)
              Padding(
                key: const Key('articlePage_shareButton'),
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: ShareButton(
                  shareText: 'Поделиться',
                  color: foregroundColor,
                  onPressed: () => context.read<ArticleBloc>().add(ShareRequested(uri: uri)),
                ),
              ),
          ],
        ),
        body: const ArticleContent(),
      ),
    );
  }

  void _onPop(BuildContext context) {
    // Removed interstitial ad logic since we don't have ads anymore
  }
}

@visibleForTesting
class HasReachedArticleLimitListener extends StatelessWidget {
  const HasReachedArticleLimitListener({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (!state.hasReachedArticleViewsLimit) {
          context.read<ArticleBloc>().add(const ArticleRequested());
        }
      },
      listenWhen: (previous, current) => previous.hasReachedArticleViewsLimit != current.hasReachedArticleViewsLimit,
      child: child,
    );
  }
}
