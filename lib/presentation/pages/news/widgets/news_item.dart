import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tags_widgets.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsItem newsItem;

  const NewsItemWidget({Key? key, required this.newsItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsPage(newsItem: newsItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: DarkThemeColors.background02,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: newsItem.images[0],
                height: 175,
                width: MediaQuery.of(context).size.width,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(newsItem.title,
                    textAlign: TextAlign.start, style: DarkTextTheme.titleM),
              ),
              const SizedBox(height: 2),
              Text((DateFormat.yMMMd('ru_RU').format(newsItem.date).toString()),
                  textAlign: TextAlign.start,
                  style: DarkTextTheme.captionL
                      .copyWith(color: DarkThemeColors.secondary)),
              const SizedBox(height: 16),
              Tags(
                isClickable: false,
                withIcon: false,
                tags: newsItem.tags,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
