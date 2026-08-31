final class GroupLinkAddress {
  const GroupLinkAddress._(this.uri);

  factory GroupLinkAddress.parse(
    String raw, {
    bool telegramOnly = false,
  }) {
    final normalized = _withScheme(raw.trim());
    final uri = Uri.tryParse(normalized);
    if (!_isSafe(uri) || telegramOnly && !_isTelegramHost(uri!.host)) {
      throw const FormatException('Invalid group link URL');
    }
    return GroupLinkAddress._(
      uri!.replace(scheme: 'https', host: uri.host.toLowerCase()),
    );
  }

  static GroupLinkAddress? tryParse(
    String raw, {
    bool telegramOnly = false,
  }) {
    try {
      return GroupLinkAddress.parse(raw, telegramOnly: telegramOnly);
    } on FormatException {
      return null;
    }
  }

  final Uri uri;

  static String _withScheme(String value) =>
      value.contains('://') ? value : 'https://$value';

  static bool _isSafe(Uri? uri) =>
      uri != null &&
      uri.scheme.toLowerCase() == 'https' &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      !uri.host.contains(RegExp(r'\s'));

  static bool _isTelegramHost(String host) {
    final normalized = host.toLowerCase();
    return normalized == 't.me' || normalized == 'telegram.me';
  }

  @override
  String toString() => uri.toString();
}
