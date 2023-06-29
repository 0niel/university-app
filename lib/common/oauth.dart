import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:rtu_mirea_app/common/constants.dart';

class MireaNinjaOauth2Client extends OAuth2Client {
  MireaNinjaOauth2Client({
    required String redirectUri,
    required String customUriScheme,
  }) : super(
          authorizeUrl: 'https://auth-app.mirea.ru/oauth/authorize',
          tokenUrl: 'https://auth-app.mirea.ru/oauth/token',
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );
}

class LksOauth2 {
  late final OAuth2Helper oauth2Helper;
  late final MireaNinjaOauth2Client oauth2Client;

  LksOauth2({
    String? redirectUri,
    String? customUriScheme,
  }) {
    oauth2Client = MireaNinjaOauth2Client(
      customUriScheme: customUriScheme ?? 'ninja.mirea.mireaapp',
      redirectUri: redirectUri ?? 'ninja.mirea.mireaapp://oauth2redirect',
    );

    oauth2Helper = OAuth2Helper(
      oauth2Client,
      grantType: OAuth2Helper.authorizationCode,
      clientId: lkClientId,
      clientSecret: lkClientSecret,
      scopes: ['profile', 'livestream', 'employees', 'attendance', 'scores'],
    );
  }
}
