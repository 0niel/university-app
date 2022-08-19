import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/utils/strapi_utils.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tags_widgets.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/images_horizontal_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({Key? key, required this.newsItem}) : super(key: key);

  final NewsItem newsItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkThemeColors.background01,
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
                      StrapiUtils.getMediumImageUrl(newsItem.images[0].formats),
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
            color: DarkThemeColors.background01,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.title,
                        style: DarkTextTheme.h5,
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
                                fontStyle: DarkTextTheme.bodyRegular.fontStyle),
                          },
                          customRenders: {
                            // iframeRenderer to display the YouTube video player
                            iframeMatcher(): iframeRender(),
                          },
                          onLinkTap:
                              (String? url, context, attributes, element) {
                            if (url != null) {
                              launch(url);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ImagesHorizontalSlider(images: newsItem.images),
                const SizedBox(height: 24),
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
  const _NewsItemInfo({Key? key, required this.tags, required this.date})
      : super(key: key);

  final List<String> tags;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: tags.isNotEmpty
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        tags.isNotEmpty
            ? Expanded(
                child: Tags(
                  isClickable: false,
                  withIcon: true,
                  tags: tags,
                ),
              )
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset("assets/icons/calendar.svg", height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Дата",
                    style: DarkTextTheme.body
                        .copyWith(color: DarkThemeColors.deactive),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.MMMd('ru_RU').format(date).toString(),
                    style: DarkTextTheme.titleM
                        .copyWith(color: DarkThemeColors.colorful02),
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
