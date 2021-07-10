class RemoteDataException implements Exception {
  final String cause;
  RemoteDataException(this.cause);
}

class CacheException implements Exception {
  final String cause;
  CacheException(this.cause);
}
