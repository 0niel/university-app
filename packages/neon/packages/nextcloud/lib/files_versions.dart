// coverage:ignore-file
import 'package:nextcloud/src/api/files_versions.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/files_versions.openapi.dart';

// ignore: public_member_api_docs
extension FilesVersionsExtension on NextcloudClient {
  static final _filesVersions = Expando<$Client>();

  /// Client for the files_versions APIs
  $Client get filesVersions => _filesVersions[this] ??= $Client.fromClient(this);
}
