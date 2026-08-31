import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;

import 'package:news_blocks/news_blocks.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template html}
/// A reusable html news block widget.
/// {@endtemplate}
class Html extends StatelessWidget {
  /// {@macro html}
  const Html({required this.block, super.key});

  /// The associated [HtmlBlock] instance.
  final HtmlBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: flutter_html.Html(
        onLinkTap: (url, attributes, element) {
          if (url == null) return;
          final uri = Uri.tryParse(url);
          if (uri == null) return;
          launchUrl(uri).ignore();
        },
        data: block.content,
        style: {
          'p': flutter_html.Style.fromTextStyle(
            text.bodyLarge ?? const TextStyle(),
          ),
          'h1': flutter_html.Style.fromTextStyle(
            text.displayLarge ?? const TextStyle(),
          ),
          'h2': flutter_html.Style.fromTextStyle(
            text.displayMedium ?? const TextStyle(),
          ),
          'h3': flutter_html.Style.fromTextStyle(
            text.displaySmall ?? const TextStyle(),
          ),
          'h4': flutter_html.Style.fromTextStyle(
            text.headlineMedium ?? const TextStyle(),
          ),
          'h5': flutter_html.Style.fromTextStyle(
            text.headlineSmall ?? const TextStyle(),
          ),
          'h6': flutter_html.Style.fromTextStyle(
            text.titleLarge ?? const TextStyle(),
          ),
        },
      ),
    );
  }
}
