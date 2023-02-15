class ServerException implements Exception {
  final String cause;
  ServerException(this.cause);
}

class NfcStaffnodeNotExistException extends ServerException {
  NfcStaffnodeNotExistException() : super("NfcStaffnodeNotExistException");
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
