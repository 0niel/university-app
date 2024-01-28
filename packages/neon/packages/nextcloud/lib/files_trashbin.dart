// coverage:ignore-file
import 'package:nextcloud/src/api/files_trashbin.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/files_trashbin.openapi.dart';

// ignore: public_member_api_docs
extension FilesTrashbinExtension on NextcloudClient {
  static final _filesTrashbin = Expando<$Client>();

  /// Client for the files_trashbin APIs
  $Client get filesTrashbin => _filesTrashbin[this] ??= $Client.fromClient(this);
}
