import 'package:neon_framework/sort_box.dart';
import 'package:neon_news/src/options.dart';
import 'package:nextcloud/news.dart' as news;

final foldersSortBox = SortBox<FoldersSortProperty, FolderFeedsWrapper>(
  properties: {
    FoldersSortProperty.alphabetical: (folderFeedsWrapper) => folderFeedsWrapper.folder.name.toLowerCase(),
    FoldersSortProperty.unreadCount: (folderFeedsWrapper) => folderFeedsWrapper.unreadCount,
  },
  boxes: const {
    FoldersSortProperty.alphabetical: {
      (property: FoldersSortProperty.unreadCount, order: SortBoxOrder.descending),
    },
    FoldersSortProperty.unreadCount: {
      (property: FoldersSortProperty.alphabetical, order: SortBoxOrder.ascending),
    },
  },
);

typedef FolderFeedsWrapper = ({news.Folder folder, int feedCount, int unreadCount});
