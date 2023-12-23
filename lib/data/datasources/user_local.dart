import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalData {
  Future<String> getTokenFromCache();
  Future<void> removeTokenFromCache();

  Future<int> getNfcCodeFromCache();
  Future<void> setNfcCodeToCache(int code);
  Future<void> removeNfcCodeFromCache();
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

  @override
  Future<int> getNfcCodeFromCache() async {
    String? value = sharedPreferences.getString('nfc_code');

    if (value == null) throw CacheException('NFC code are not set');

    return Future.value(int.parse(value));
  }

  @override
  Future<void> setNfcCodeToCache(int code) async {
    await sharedPreferences.setString('nfc_code', code.toString());
  }

  @override
  Future<void> removeNfcCodeFromCache() async {
    await sharedPreferences.remove('nfc_code');
  }
}
