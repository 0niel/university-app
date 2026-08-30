/// gRPC-Web endpoints required to issue a digital NFC pass.
final class NfcPassEndpoints {
  /// Creates endpoint configuration for an institution's pass provider.
  const NfcPassEndpoints({
    required this.accessTokenUrl,
    required this.sendVerificationCodeUrl,
    required this.getDigitalPassUrl,
  });

  /// Obtains a short-lived token for the pass flow.
  final Uri accessTokenUrl;

  /// Sends the verification code to the authenticated user.
  final Uri sendVerificationCodeUrl;

  /// Exchanges a verified code for a digital pass identifier.
  final Uri getDigitalPassUrl;
}
