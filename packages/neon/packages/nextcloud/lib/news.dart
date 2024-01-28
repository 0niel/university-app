// coverage:ignore-file
import 'package:nextcloud/src/api/news.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/news.openapi.dart';
export 'src/helpers/news.dart';

// ignore: public_member_api_docs
extension NewsExtension on NextcloudClient {
  static final _news = Expando<$Client>();

  /// Client for the news APIs
  $Client get news => _news[this] ??= $Client.fromClient(this);
}
