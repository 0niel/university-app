final class NfcPassTransportException implements Exception {
  const NfcPassTransportException(
    this.message, {
    this.httpStatusCode,
    this.grpcStatus,
    this.redirectLocation,
  });

  final String message;
  final int? httpStatusCode;
  final int? grpcStatus;

  /// `Location` header of a redirect response, when the server answered
  /// with one instead of a gRPC-Web payload.
  final String? redirectLocation;

  static const _redirectStatuses = {301, 302, 303, 307, 308};

  /// The session cookie is missing, expired or rejected. Besides `401` and
  /// gRPC `UNAUTHENTICATED`, the pass backend redirects unauthenticated calls
  /// to its login page, so a redirect there means the same thing.
  bool get requiresAuthentication =>
      httpStatusCode == 401 || grpcStatus == 16 || isLoginRedirect;

  bool get isLoginRedirect {
    final status = httpStatusCode;
    final location = redirectLocation;
    if (status == null || location == null) return false;
    if (!_redirectStatuses.contains(status)) return false;
    final path = Uri.tryParse(location)?.path.toLowerCase();
    return path != null && path.contains('/auth/login');
  }

  @override
  String toString() => 'NfcPassTransportException: $message';
}

/// The pass backend could not be reached: DNS, TCP or TLS failed, or the
/// request timed out before a response arrived. The session is not to blame.
final class NfcPassUnreachableException implements Exception {
  const NfcPassUnreachableException(this.host, {this.cause});

  final String host;
  final Object? cause;

  @override
  String toString() =>
      'NfcPassUnreachableException: $host is unreachable ($cause)';
}
