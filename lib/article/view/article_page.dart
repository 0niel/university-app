import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/bloc/article_bloc.dart';
import 'package:rtu_mirea_app/article/cubit/cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleBloc(
            id: id,
            shareLauncher: const ShareLauncher(),
            articleRepository: context.read(),
          )..add(const ArticleRequested()),
        ),
        BlocProvider(create: (_) => SavedArticlesCubit()),
        BlocProvider(create: (_) => FollowedSourcesCubit()),
      ],
      child: ArticleView(isVideoArticle: isVideoArticle),
    );
  }
}
