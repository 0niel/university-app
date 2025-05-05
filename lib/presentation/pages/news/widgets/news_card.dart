import 'package:analytics_repository/analytics_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:app_ui/app_ui.dart';

// Import our extracted widgets
import 'news_card_date.dart';
import 'news_tags.dart';

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final Function(String)? onClickNewsTag;
  final bool isCompactLayout;

  const NewsCard({super.key, required this.newsItem, this.onClickNewsTag, this.isCompactLayout = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.go('/news/details', extra: newsItem);
          context.read<AnalyticsBloc>().add(TrackAnalyticsEvent(ViewNews(articleTitle: newsItem.title)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [_buildImage(context), _buildCardContent(context, colors)],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (newsItem.images.isEmpty) {
      return Container(
        width: double.infinity,
        color: colors.background03,
        child: Center(child: Icon(Icons.image_not_supported_outlined, color: colors.deactive, size: 24)),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        color: colors.background03,
        child: ExtendedImage.network(
          newsItem.images[0],
          fit: BoxFit.cover,
          cache: true,
          loadStateChanged: (state) {
            if (state.extendedImageLoadState == LoadState.loading) {
              return Container(width: double.infinity, height: double.infinity, color: colors.background03);
            }
            if (state.extendedImageLoadState == LoadState.failed) {
              return Center(child: Icon(Icons.image_not_supported_outlined, color: colors.deactive, size: 24));
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsCardDate(date: newsItem.date),
          const SizedBox(height: 8),

          Text(
            newsItem.title,
            style:
                isCompactLayout
                    ? AppTextStyle.body.copyWith(fontWeight: FontWeight.w600, height: 1.2)
                    : AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600, height: 1.2),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (NewsBloc.isTagsNotEmpty(newsItem.tags))
            NewsTags(
              tags: newsItem.tags,
              onClick: onClickNewsTag,
              maxTags: isCompactLayout ? 1 : 2,
              isCompact: isCompactLayout,
            ),
        ],
      ),
    );
  }
}
