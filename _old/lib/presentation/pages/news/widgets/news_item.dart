import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/strapi_utils.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/core/routes/routes.gr.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/tags_widgets.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shimmer/shimmer.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsItem newsItem;
  final Function(String)? onClickNewsTag;

  const NewsItemWidget({Key? key, required this.newsItem, this.onClickNewsTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(NewsDetailsRoute(
          newsItem: newsItem,
        ));
        FirebaseAnalytics.instance.logEvent(name: 'view_news', parameters: {
          'news_title': newsItem.title,
        });
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
              ExtendedImage.network(
                StrapiUtils.getMediumImageUrl(newsItem.images[0].formats),
                height: 175,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                cache: false,
                borderRadius: BorderRadius.circular(16),
                shape: BoxShape.rectangle,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Container(
                        child: Shimmer.fromColors(
                          baseColor: DarkThemeColors.background03,
                          highlightColor:
                              DarkThemeColors.background03.withOpacity(0.5),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: DarkThemeColors.background03,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );

                    case LoadState.completed:
                      return Container(
                        child: ExtendedRawImage(
                          fit: BoxFit.cover,
                          height: 175,
                          width: double.infinity,
                          image: state.extendedImageInfo?.image,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );

                    case LoadState.failed:
                      return GestureDetector(
                        child: Stack(
                          fit: StackFit.expand,
                          children: const <Widget>[
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Text(
                                "Ошибка при загрузке изображения. Нажмите, чтобы перезагрузить",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(newsItem.title,
                    textAlign: TextAlign.start, style: DarkTextTheme.titleM),
              ),
              const SizedBox(height: 4),
              Text((DateFormat.yMMMd('ru_RU').format(newsItem.date).toString()),
                  textAlign: TextAlign.start,
                  style: DarkTextTheme.captionL
                      .copyWith(color: DarkThemeColors.secondary)),
              newsItem.tags.isNotEmpty
                  ? const SizedBox(height: 16)
                  : Container(),
              Tags(
                isClickable: true,
                withIcon: false,
                tags: newsItem.tags,
                onClick: onClickNewsTag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
