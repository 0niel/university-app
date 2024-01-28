import 'package:neon_framework/sort_box.dart';
import 'package:neon_news/src/options.dart';
import 'package:nextcloud/news.dart' as news;

final feedsSortBox = SortBox<FeedsSortProperty, news.Feed>(
  properties: {
    FeedsSortProperty.alphabetical: (feed) => feed.title.toLowerCase(),
    FeedsSortProperty.unreadCount: (feed) => feed.unreadCount ?? 0,
  },
  boxes: const {
    FeedsSortProperty.alphabetical: {
      (property: FeedsSortProperty.unreadCount, order: SortBoxOrder.descending),
    },
    FeedsSortProperty.unreadCount: {
      (property: FeedsSortProperty.alphabetical, order: SortBoxOrder.ascending),
    },
  },
);
