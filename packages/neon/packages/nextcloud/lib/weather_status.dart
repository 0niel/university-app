// coverage:ignore-file
import 'package:nextcloud/src/api/weather_status.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/weather_status.openapi.dart';

// ignore: public_member_api_docs
extension WeatherStatusExtension on NextcloudClient {
  static final _weatherStatus = Expando<$Client>();

  /// Client for the weather_status APIs
  $Client get weatherStatus => _weatherStatus[this] ??= $Client.fromClient(this);
}
