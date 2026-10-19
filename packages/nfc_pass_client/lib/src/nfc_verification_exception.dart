final class NfcVerificationException implements Exception {
  const NfcVerificationException(this.failure);

  final NfcVerificationFailure failure;

  @override
  String toString() => 'NfcVerificationException(${failure.name})';
}

enum NfcVerificationFailure { wrongCode, nfcError }
