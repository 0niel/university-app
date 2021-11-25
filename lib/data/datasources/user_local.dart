import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalData {
  Future<void> setTokenToCache(String token);
  Future<String> getTokenFromCache();
  Future<void> removeTokenFromCache();
}

class UserLocalDataImpl implements UserLocalData {
  final SharedPreferences sharedPreferences;

  UserLocalDataImpl({required this.sharedPreferences});

  @override
  Future<void> setTokenToCache(String token) {
    return sharedPreferences.setString('auth_token', token);
  }

  @override
  Future<String> getTokenFromCache() {
    String? token = sharedPreferences.getString('auth_token');
    if (token == null) throw CacheException('Auth token are not set');
    return Future.value(token);
  }

  @override
  Future<void> removeTokenFromCache() {
    return sharedPreferences.remove('auth_token');
  }
}
