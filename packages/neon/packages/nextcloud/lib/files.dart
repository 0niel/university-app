// coverage:ignore-file
import 'package:nextcloud/src/api/files.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/files.openapi.dart';

// ignore: public_member_api_docs
extension FilesExtension on NextcloudClient {
  static final _files = Expando<$Client>();

  /// Client for the files APIs
  $Client get files => _files[this] ??= $Client.fromClient(this);
}
