import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rtu_mirea_app/article/widgets/article_media.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_image.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleHtml extends StatelessWidget {
  const ArticleHtml({
    required this.content,
    super.key,
    this.sourceUri,
    this.gallery = const [],
    this.extensions = const [],
    this.style = const {},
  });

  final String content;
  final Uri? sourceUri;
  final List<String> gallery;
  final List<HtmlExtension> extensions;
  final Map<String, Style> style;

  Future<void> _openLink(BuildContext context, String? url) async {
    final uri = articleLinkUri(url, sourceUri: sourceUri);
    var opened = false;
    try {
      if (uri != null) {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } on Exception {
      opened = false;
    }
    if (!opened && context.mounted) {
      showNinjaToast(context, message: context.l10n.error, showCheck: false);
    }
  }

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
      extensions: [
        TagExtension(
          tagsToExtend: {'img'},
          builder: (extension) {
            final url = articleImageUrl(
              extension.attributes['src'] ?? extension.attributes['data-src'],
              sourceUri: sourceUri,
            );
            var anchor = extension.element?.parent;
            while (anchor != null && anchor.localName != 'a') {
              anchor = anchor.parent;
            }
            final original = articleLightboxImageUrl(
              anchor?.attributes['href'],
              classes: anchor?.classes ?? const [],
              sourceUri: sourceUri,
            );
            return FeedImage(
              imageUrl: url,
              previewImageUrl: original,
              enablePreview:
                  anchor?.attributes['href'] == null || original != null,
              gallery: gallery.isEmpty
                  ? articleHtmlImages(content, sourceUri: sourceUri)
                  : gallery,
              radius: AppRadius.card,
              width: double.infinity,
              height: 220,
            );
          },
        ),
        ...extensions,
      ],
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
        ...style,
      },
      onLinkTap: (url, _, _) {
        unawaited(_openLink(context, url));
      },
    );
  }
}
