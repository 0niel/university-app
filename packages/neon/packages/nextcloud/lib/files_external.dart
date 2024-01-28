// coverage:ignore-file
import 'package:nextcloud/src/api/files_external.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/files_external.openapi.dart';

// ignore: public_member_api_docs
extension FilesExternalExtension on NextcloudClient {
  static final _filesExternal = Expando<$Client>();

  /// Client for the files_external APIs
  $Client get filesExternal => _filesExternal[this] ??= $Client.fromClient(this);
}
