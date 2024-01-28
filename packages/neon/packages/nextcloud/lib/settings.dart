// coverage:ignore-file
import 'package:nextcloud/src/api/settings.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/settings.openapi.dart';

// ignore: public_member_api_docs
extension SettingsExtension on NextcloudClient {
  static final _settings = Expando<$Client>();

  /// Client for the settings APIs
  $Client get settings => _settings[this] ??= $Client.fromClient(this);
}
