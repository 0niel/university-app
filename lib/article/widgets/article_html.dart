import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleHtml extends StatelessWidget {
  const ArticleHtml({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final paragraph = AppText.paragraph.copyWith(
      color: colors.ink,
      height: 1.55,
    );
    Style text(TextStyle style) => Style.fromTextStyle(
      style,
    ).copyWith(margin: Margins.zero, padding: HtmlPaddings.zero);
    Style heading(double size) => text(
      AppText.sans(
        size,
        FontWeight.w700,
        height: 1.25,
      ).copyWith(color: colors.ink),
    ).copyWith(margin: Margins.only(top: 14, bottom: 6));
    return Html(
      data: content,
      style: {
        'html': text(paragraph),
        'body': text(paragraph),
        'p': text(paragraph).copyWith(margin: Margins.only(bottom: 14)),
        'a': text(paragraph.copyWith(color: colors.accent)),
        'h1': heading(22),
        'h2': heading(20),
        'h3': heading(19),
        'h4': heading(17),
        'h5': heading(16),
        'h6': heading(15),
      },
      onLinkTap: (url, _, _) {
        final uri = url == null ? null : Uri.tryParse(url);
        if (uri == null) return;
        launchUrl(uri, mode: LaunchMode.externalApplication).ignore();
      },
    );
  }
}
