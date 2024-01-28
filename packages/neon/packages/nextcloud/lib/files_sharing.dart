// coverage:ignore-file
import 'package:nextcloud/src/api/files_sharing.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/files_sharing.openapi.dart';

// ignore: public_member_api_docs
extension FilesSharingExtension on NextcloudClient {
  static final _filesSharing = Expando<$Client>();

  /// Client for the files_sharing APIs
  $Client get filesSharing => _filesSharing[this] ??= $Client.fromClient(this);
}
