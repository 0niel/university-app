class ServerException implements Exception {
  final String cause;
  ServerException(this.cause);
}

class CacheException implements Exception {
  final String cause;
  CacheException(this.cause);
}

/// Thrown when parsing fails
class ParsingException implements Exception {
  final String cause;
  ParsingException(this.cause);
}
