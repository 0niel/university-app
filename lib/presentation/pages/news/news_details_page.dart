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
    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColors>()!.background01,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.6,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      newsItem.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Theme.of(context).extension<AppColors>()!.background01,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.title,
                        style: AppTextStyle.h5,
                      ),
                      const SizedBox(height: 24),
                      _NewsItemInfo(tags: newsItem.tags, date: newsItem.date),
                      Padding(
                        // News text content
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Html(
                          data: newsItem.text,
                          style: {
                            "body": Style(
                              color: Theme.of(context).extension<AppColors>()!.active,
                              fontStyle: AppTextStyle.bodyRegular
                                  .copyWith(
                                    color: Theme.of(context).extension<AppColors>()!.active,
                                  )
                                  .fontStyle,
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.5),
                            ),
                            "a": Style(
                              color: Theme.of(context).extension<AppColors>()!.colorful02,
                              fontStyle: AppTextStyle.bodyRegular.fontStyle,
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.5),
                            ),
                            "p": Style(
                              color: Theme.of(context).extension<AppColors>()!.active,
                              fontStyle: AppTextStyle.bodyRegular
                                  .copyWith(
                                    color: Theme.of(context).extension<AppColors>()!.active,
                                  )
                                  .fontStyle,
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.5),
                            ),
                          },
                          extensions: const [
                            // to display the YouTube video player
                            IframeHtmlExtension(),
                          ],
                          onLinkTap: (String? url, Map<String, String> attributes, _) {
                            if (url != null) {
                              launchUrlString(url);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ImagesHorizontalSlider(images: newsItem.images),
                const SizedBox(height: 24),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tags and date of publication of the news
class _NewsItemInfo extends StatelessWidget {
  const _NewsItemInfo({required this.tags, required this.date});

  final List<String> tags;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: NewsBloc.isTagsNotEmpty(tags) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        NewsBloc.isTagsNotEmpty(tags)
            ? Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    tags.length,
                    (index) => TagBadge(
                      tag: tags[index],
                    ),
                  ),
                ),
              )
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.icons.calendar.svg(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Дата",
                    style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
                  ),
                  Text(
                    DateFormat.MMMd('ru_RU').format(date).toString(),
                    style: AppTextStyle.titleM.copyWith(color: Theme.of(context).extension<AppColors>()!.colorful02),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
