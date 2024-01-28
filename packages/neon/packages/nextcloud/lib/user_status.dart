// coverage:ignore-file
import 'package:nextcloud/src/api/user_status.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/user_status.openapi.dart';

// ignore: public_member_api_docs
extension UserStatusExtension on NextcloudClient {
  static final _userStatus = Expando<$Client>();

  /// Client for the user_status APIs
  $Client get userStatus => _userStatus[this] ??= $Client.fromClient(this);
}
