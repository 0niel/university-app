sealed class NfcVerificationResult {
  const NfcVerificationResult();
}

final class NfcVerificationCodeSent extends NfcVerificationResult {
  const NfcVerificationCodeSent({this.retryAt});

  final DateTime? retryAt;
}

final class NfcVerificationCooldown extends NfcVerificationResult {
  const NfcVerificationCooldown({required this.retryAt});

  final DateTime retryAt;
}

final class NfcVerificationUnavailable extends NfcVerificationResult {
  const NfcVerificationUnavailable();
}
