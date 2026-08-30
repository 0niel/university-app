import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'article_bar.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({required this.isVideoArticle, super.key});

  final bool isVideoArticle;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final uri = context.select<ArticleBloc, Uri?>((bloc) => bloc.state.uri);
    final canShare = uri != null && uri.toString().isNotEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: _ArticleBar(
        title: context.l10n.news,
        backLabel: context.l10n.back,
        shareLabel: context.l10n.share,
        canShare: canShare,
        onBack: Navigator.of(context).pop,
        onShare: canShare
            ? () => context.read<ArticleBloc>().add(ShareRequested(uri: uri))
            : null,
      ),
      body: const ArticleContent(),
    );
  }
}
