import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:rtu_mirea_app/article/widgets/article_html.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_formatting.dart';

class PostOverviewHtml extends StatelessWidget {
  const PostOverviewHtml({required this.data, this.sourceUri, super.key});

  final String data;
  final Uri? sourceUri;

  @override
  Widget build(BuildContext context) {
    return ArticleHtml(
      content: data,
      sourceUri:
          sourceUri ??
          Uri.tryParse(context.read<UniversityConfig>().communityForumUrl),
      extensions: const [TableHtmlExtension(), VideoHtmlExtension()],
      style: postOverviewHtmlStyle(context),
    );
  }
}
