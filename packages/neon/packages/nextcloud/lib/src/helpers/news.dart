// ignore_for_file: public_member_api_docs

import 'package:nextcloud/src/api/news.openapi.dart' as news;
import 'package:nextcloud/src/helpers/common.dart';
import 'package:version/version.dart';

/// Minimum API version of the news app supported
final minVersion = Version(1, 3, 0);

extension NewsVersionCheck on news.$Client {
  /// Check if the news app version is supported by this client
  ///
  /// Also returns the supported API version number
  Future<VersionCheck> getVersionCheck() async {
    final response = await getSupportedApiVersions();
    final versions = response.body.apiLevels;
    return VersionCheck(
      versions: versions?.map((version) => Version.parse(version.substring(1).replaceAll('-', '.'))).toList(),
      minimumVersion: minVersion,
      maximumMajor: null,
    );
  }
}

/// See https://github.com/nextcloud/news/blob/4a107b3d53c4fe651ac704251b99e04a53cd587f/lib/Db/ListType.php
enum ListType {
  feed,
  folder,
  starred,
  allItems,
  shared,
  explore,
  unread,
}
