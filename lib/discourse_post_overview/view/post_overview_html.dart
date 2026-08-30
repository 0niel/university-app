import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_formatting.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostOverviewHtml extends StatelessWidget {
  const PostOverviewHtml({required this.data, super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      extensions: const [TableHtmlExtension(), VideoHtmlExtension()],
      style: postOverviewHtmlStyle(context),
      onLinkTap: (url, _, _) {
        if (url != null) {
          unawaited(launchUrlString(url, mode: .externalApplication));
        }
      },
    );
  }
}
