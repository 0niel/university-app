import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/article/view/article_view.dart';
import 'package:rtu_mirea_app/article/view/interstitial_ad_behavior.dart';
import 'package:share_launcher/share_launcher.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    required this.id,
    required this.isVideoArticle,
    required this.interstitialAdBehavior,
    super.key,
  });

  final String id;
  final bool isVideoArticle;
  final InterstitialAdBehavior interstitialAdBehavior;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(
        id: id,
        shareLauncher: const ShareLauncher(),
        articleRepository: context.read(),
      )..add(const ArticleRequested()),
      child: ArticleView(isVideoArticle: isVideoArticle),
    );
  }
}
