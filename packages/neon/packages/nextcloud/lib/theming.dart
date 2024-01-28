// coverage:ignore-file
import 'package:nextcloud/src/api/theming.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/theming.openapi.dart';

// ignore: public_member_api_docs
extension ThemingExtension on NextcloudClient {
  static final _theming = Expando<$Client>();

  /// Client for the theming APIs
  $Client get theming => _theming[this] ??= $Client.fromClient(this);
}
