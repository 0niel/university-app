final class NfcPassConfig {
  const NfcPassConfig({
    required this.oauthUrl,
    required this.redirectUrls,
    required this.accessTokenUrl,
    required this.sendVerificationCodeUrl,
    required this.getDigitalPassUrl,
  });

  static const legacyHosts = {'attendance.mirea.ru': 'pulse.mirea.ru'};

  final String oauthUrl;

  final List<String> redirectUrls;

  final String accessTokenUrl;

  final String sendVerificationCodeUrl;

  final String getDigitalPassUrl;

  NfcPassConfig get canonical => NfcPassConfig(
    oauthUrl: canonicalUrl(oauthUrl),
    redirectUrls: redirectUrls.map(canonicalUrl).toList(growable: false),
    accessTokenUrl: canonicalUrl(accessTokenUrl),
    sendVerificationCodeUrl: canonicalUrl(sendVerificationCodeUrl),
    getDigitalPassUrl: canonicalUrl(getDigitalPassUrl),
  );

  static String canonicalUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.userInfo.isNotEmpty) return url;
    final host = legacyHosts[uri.host];
    if (host == null) return url;
    final authority = uri.hasPort ? '$host:${uri.port}' : host;
    final prefix = '${uri.scheme}://${uri.authority}';
    if (!url.startsWith(prefix)) return url;
    return '${uri.scheme}://$authority${url.substring(prefix.length)}';
  }
}
