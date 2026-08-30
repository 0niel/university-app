import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

String avatarUrl(String forumUrl, String avatarTemplate) => Uri.parse(
  forumUrl,
).resolve(avatarTemplate.replaceAll('{size}', '100')).toString();

String formatPostDate(DateTime date) =>
    DateFormat('dd.MM.yyyy HH:mm').format(date);

Map<String, Style> postOverviewHtmlStyle(BuildContext context) {
  final colors = context.ninja;
  Style heading(TextStyle source, double size) => .new(
    color: colors.ink,
    fontStyle: source.fontStyle,
    fontSize: FontSize(size),
    lineHeight: const LineHeight(1.5),
  );
  final bodyStyle = Style(
    color: colors.ink,
    fontStyle: NinjaText.body.copyWith(color: colors.ink).fontStyle,
    fontSize: FontSize(16),
    lineHeight: const LineHeight(1.5),
  );

  return {
    'h1': heading(NinjaText.display, 24),
    'h2': heading(NinjaText.display, 20),
    'h3': heading(NinjaText.display, 18),
    'h4': heading(NinjaText.display, 16),
    'h5': heading(NinjaText.title, 14),
    'h6': heading(NinjaText.headline, 12),
    'body': bodyStyle,
    'p': bodyStyle,
    'a': Style(
      color: colors.orange,
      fontStyle: NinjaText.body.fontStyle,
      fontSize: FontSize(16),
      lineHeight: const LineHeight(1.5),
    ),
  };
}
