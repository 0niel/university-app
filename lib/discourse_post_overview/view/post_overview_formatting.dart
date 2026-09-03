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
  final colors = context.colors;
  Style textStyle(TextStyle source) => .new(
    color: colors.ink,
    fontFamily: source.fontFamily,
    fontWeight: source.fontWeight,
    fontStyle: source.fontStyle,
    fontSize: FontSize(source.fontSize ?? AppText.body.fontSize!),
    lineHeight: LineHeight(source.height ?? 1.5),
  );
  final bodyStyle = textStyle(AppText.paragraph);

  return {
    'h1': textStyle(AppText.sectionLarge),
    'h2': textStyle(AppText.section),
    'h3': textStyle(AppText.sectionSmall),
    'h4': textStyle(AppText.heading),
    'h5': textStyle(AppText.bodyStrong),
    'h6': textStyle(AppText.captionStrong),
    'body': bodyStyle.copyWith(
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
    'p': bodyStyle,
    'a': bodyStyle.copyWith(color: colors.accent),
  };
}
