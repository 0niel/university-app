// coverage:ignore-file
import 'package:nextcloud/src/api/spreed.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/spreed.openapi.dart';
export 'src/helpers/spreed.dart';

// ignore: public_member_api_docs
extension SpreedExtension on NextcloudClient {
  static final _spreed = Expando<$Client>();

  /// Client for the spreed APIs
  $Client get spreed => _spreed[this] ??= $Client.fromClient(this);
}
