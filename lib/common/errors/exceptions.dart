class ServerException implements Exception {
  final String cause;
  ServerException(this.cause);
}

class CacheException implements Exception {
  final String cause;
  CacheException(this.cause);
}
