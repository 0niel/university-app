import 'package:neon_files/src/options.dart';
import 'package:neon_framework/sort_box.dart';
import 'package:nextcloud/webdav.dart';

final filesSortBox = SortBox<FilesSortProperty, WebDavFile>(
  properties: {
    FilesSortProperty.name: (file) => file.name.toLowerCase(),
    FilesSortProperty.modifiedDate: (file) => file.lastModified?.millisecondsSinceEpoch ?? 0,
    FilesSortProperty.size: (file) => file.size ?? 0,
    FilesSortProperty.isFolder: (file) => file.isDirectory ? 0 : 1,
  },
  boxes: const {
    FilesSortProperty.modifiedDate: {
      (property: FilesSortProperty.name, order: SortBoxOrder.ascending),
    },
    FilesSortProperty.size: {
      (property: FilesSortProperty.name, order: SortBoxOrder.ascending),
    },
  },
);
