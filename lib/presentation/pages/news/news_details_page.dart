import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tag_badge.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({super.key, required this.newsItem});

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background01,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: colors.active)),
      body: Stack(
        children: [
          // Banner image with gradient overlay
          Positioned.fill(
            child: Hero(
              tag: 'news_${newsItem.title}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: ExtendedImage.network(
                  newsItem.images[0],
                  fit: BoxFit.cover,
                  cache: true,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Container(
                        color: colors.background03,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return Container(
                        color: colors.background03,
                        child: Center(child: Icon(Icons.error_outline, color: colors.deactive, size: 40)),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          // Gradient overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark ? Colors.black.withOpacity(0.85) : Colors.white.withOpacity(0.92),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
          // Main content card
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.38, left: 0, right: 0, bottom: 0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: colors.background01.withOpacity(isDark ? 0.95 : 0.98),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: colors.background03.withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NewsDateBadge(date: newsItem.date),
                          const SizedBox(height: 18),
                          Text(
                            newsItem.title,
                            style: AppTextStyle.h4.copyWith(fontWeight: FontWeight.w800, height: 1.25),
                          ),
                          if (NewsBloc.isTagsNotEmpty(newsItem.tags)) ...[
                            const SizedBox(height: 18),
                            NewsTags(tags: newsItem.tags),
                          ],
                          const SizedBox(height: 28),
                          NewsContent(content: newsItem.text),
                        ],
                      ),
                    ),

                    if (newsItem.images.length > 1) ...[ImagesHorizontalSlider(images: newsItem.images)],
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsDateBadge extends StatelessWidget {
  final DateTime date;

  const NewsDateBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
      child: Text(
        DateFormat.yMMMd('ru_RU').format(date).toString(),
        style: AppTextStyle.captionL.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class NewsTags extends StatelessWidget {
  final List<String> tags;

  const NewsTags({super.key, required this.tags});

  Color _getTagColor(int index, BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorList = [
      colors.colorful01,
      colors.colorful02,
      colors.colorful03,
      colors.colorful04,
      colors.colorful05,
      colors.colorful06,
      colors.colorful07,
    ];

    return colorList[index % colorList.length];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(tags.length, (index) => TagBadge(tag: tags[index], color: _getTagColor(index, context))),
    );
  }
}

class NewsContent extends StatelessWidget {
  final String content;

  const NewsContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Html(
      data: content,
      style: {
        "body": Style(
          color: colors.active,
          fontFamily: 'Inter',
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          margin: Margins.zero,
        ),
        "p": Style(
          color: colors.active,
          fontFamily: 'Inter',
          fontSize: FontSize(16),
          lineHeight: const LineHeight(1.6),
          margin: Margins.only(bottom: 16),
          textAlign: TextAlign.start,
        ),
        "a": Style(
          color: colors.primary,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          textDecoration: TextDecoration.none,
        ),
        "h1, h2, h3, h4, h5, h6": Style(
          color: colors.active,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          lineHeight: const LineHeight(1.3),
          margin: Margins.only(top: 16, bottom: 8),
        ),
        "ul, ol": Style(margin: Margins.only(bottom: 16, left: 8)),
        "li": Style(margin: Margins.only(bottom: 8), lineHeight: const LineHeight(1.6)),
        "img": Style(
          margin: Margins.symmetric(vertical: 16),
          padding: HtmlPaddings.all(2),
          border: Border.all(color: colors.divider, width: 1),
        ),
        "blockquote": Style(
          backgroundColor: colors.background03,
          padding: HtmlPaddings.all(16),
          margin: Margins.symmetric(vertical: 16),
          border: Border(left: BorderSide(color: colors.primary, width: 4)),
        ),
      },
      extensions: const [IframeHtmlExtension()],
      onLinkTap: (String? url, Map<String, String> attributes, _) {
        if (url != null) {
          launchUrlString(url);
        }
      },
    );
  }
}
