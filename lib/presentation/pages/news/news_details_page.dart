import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tags_widgets.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/fullscreen_image.dart';
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
              actionsIconTheme: IconThemeData(opacity: 0.0),
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
          child: Container(
            color: DarkThemeColors.background01,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.title,
                        style: DarkTextTheme.h5,
                      ),
                      SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Tags(
                            isClickable: false,
                            withIcon: true,
                            tags: newsItem.tags,
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset("assets/icons/calendar.svg",
                                  height: 50),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Дата",
                                      style: DarkTextTheme.body.copyWith(
                                          color: DarkThemeColors.deactive),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat.MMMd('ru_RU')
                                          .format(newsItem.date)
                                          .toString(),
                                      style: DarkTextTheme.titleM.copyWith(
                                          color: DarkThemeColors.colorful02),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: MarkdownBody(
                          styleSheet: MarkdownStyleSheet(
                            a: DarkTextTheme.body
                                .copyWith(color: DarkThemeColors.secondary),
                            p: DarkTextTheme.body,
                            h1: DarkTextTheme.h1,
                            h2: DarkTextTheme.h2,
                            h3: DarkTextTheme.h3,
                            h4: DarkTextTheme.h4,
                            h5: DarkTextTheme.h5,
                            h6: DarkTextTheme.h6,
                          ),
                          onTapLink: (text, url, title) {
                            if (url != null) launch(url);
                          },
                          data: newsItem.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 112,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      newsItem.images.length,
                      (index) {
                        if (index != 0) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return FullScreenImage(
                                  imageUrl: newsItem.images[index],
                                );
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  newsItem.images[index],
                                  height: 112,
                                  width: 158,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else
                          return Container();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
