import 'dart:io';

import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:rtu_mirea_app/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MireaNinjaOauth2Client extends OAuth2Client {
  MireaNinjaOauth2Client({
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
          authorizeUrl: 'https://auth-app.mirea.ru/oauth/authorize',
          tokenUrl: 'https://auth-app.mirea.ru/oauth/token',
        );
}

final isDesktop = !(Platform.isAndroid || Platform.isIOS);

class LksOauth2 {
  late final OAuth2Helper oauth2Helper;
  late final MireaNinjaOauth2Client oauth2Client;

  LksOauth2({
    String? redirectUri,
    String? customUriScheme,
  }) {
    if (!isDesktop) {
      redirectUri = 'ninja.mirea.mireaapp://oauth2redirect';
      customUriScheme = 'ninja.mirea.mireaapp';
    } else {
      redirectUri = 'http://localhost:9094/oauth2redirect';
      customUriScheme = 'http://localhost:9094/oauth2redirect';
    }
    oauth2Client = MireaNinjaOauth2Client(
      customUriScheme: customUriScheme,
      redirectUri: redirectUri,
    );

    oauth2Helper = OAuth2Helper(oauth2Client,
        grantType: OAuth2Helper.authorizationCode,
        clientId: lkClientId,
        clientSecret: lkClientSecret,
        scopes: ['profile', 'livestream', 'employees', 'attendance', 'scores'],
        webAuthOpts: {
          'useWebview': false,
        },
        tokenStorage: isDesktop ? TokenStorage('windows', storage: _WindowsTokenStorage()) : null);
  }
}

class _WindowsTokenStorage extends BaseStorage {
  _WindowsTokenStorage();

  @override
  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
