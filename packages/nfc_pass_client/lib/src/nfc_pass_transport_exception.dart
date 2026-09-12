final class NfcPassTransportException implements Exception {
  const NfcPassTransportException(
    this.message, {
    this.httpStatusCode,
    this.grpcStatus,
  });

  final String message;
  final int? httpStatusCode;
  final int? grpcStatus;

  bool get requiresAuthentication => httpStatusCode == 401 || grpcStatus == 16;

  @override
  String toString() => 'NfcPassTransportException: $message';
}
