import 'package:dynamite_runtime/http_client.dart';
import 'package:universal_io/io.dart';

/// Different app types to register for
enum AppType {
  /// Will only receive Talk notifications
  talk('Mozilla/5.0 (Android) Nextcloud-Talk'),

  /// Will receive all notifications except Talk notifications if another Talk
  /// app is already registered for the user
  nextcloud('Mozilla/5.0 (Android) Nextcloud-android'),

  /// Default. Same problem with notifications as the [nextcloud] type
  unknown(null);

  // ignore: public_member_api_docs
  const AppType(this.userAgent);

  // ignore: public_member_api_docs
  final String? userAgent;
}

// ignore: public_member_api_docs
class NextcloudClient extends DynamiteClient {
  // ignore: public_member_api_docs
  NextcloudClient(
    super.baseURL, {
    this.loginName,
    String? password,
    String? appPassword,
    String? language,
    AppType appType = AppType.unknown,
    String? userAgentOverride,
    super.httpClient,
    super.cookieJar,
  }) : super(
          baseHeaders: {
            if (language != null) HttpHeaders.acceptLanguageHeader: language,
            if ((userAgentOverride ?? appType.userAgent) != null)
              HttpHeaders.userAgentHeader: userAgentOverride ?? appType.userAgent!,
          },
          authentications: [
            if (appPassword != null)
              DynamiteHttpBearerAuthentication(
                token: appPassword,
              ),
            if (loginName != null && (password ?? appPassword) != null)
              DynamiteHttpBasicAuthentication(
                username: loginName,
                password: (password ?? appPassword)!,
              ),
          ],
        );

  /// Identifier used for authentication. This can be the username or email or something else.
  final String? loginName;
}
