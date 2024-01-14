import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalData {
  Future<String> getTokenFromCache();
  Future<void> removeTokenFromCache();
}

class UserLocalDataImpl implements UserLocalData {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  final OAuth2Helper oauthHelper;

  UserLocalDataImpl({
    required this.sharedPreferences,
    required this.secureStorage,
    required this.oauthHelper,
  });

  @override
  Future<String> getTokenFromCache() async {
    var token = await oauthHelper.getTokenFromStorage();
    if (token == null) throw CacheException('Auth token are not set');
    return Future.value(token.accessToken);
  }

  @override
  Future<void> removeTokenFromCache() {
    return oauthHelper.removeAllTokens();
  }
}
