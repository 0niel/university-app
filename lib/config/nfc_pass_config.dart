final class NfcPassConfig {
  const NfcPassConfig({
    required this.oauthUrl,
    required this.redirectUrls,
    required this.accessTokenUrl,
    required this.sendVerificationCodeUrl,
    required this.getDigitalPassUrl,
  });

  final String oauthUrl;

  final List<String> redirectUrls;

  final String accessTokenUrl;

  final String sendVerificationCodeUrl;

  final String getDigitalPassUrl;
}
