// coverage:ignore-file
import 'package:nextcloud/src/api/core.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/core.openapi.dart';
export 'src/helpers/core.dart';

// ignore: public_member_api_docs
extension CoreExtension on NextcloudClient {
  static final _core = Expando<$Client>();

  /// Client for the core APIs
  $Client get core => _core[this] ??= $Client.fromClient(this);
}
