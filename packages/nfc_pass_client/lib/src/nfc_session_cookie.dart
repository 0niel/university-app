String nfcSessionCookieHeader(String cookie) {
  if (cookie.isEmpty || cookie.length > 65536) {
    throw const FormatException('Invalid session cookie.');
  }
  final cookies = <String, String>{};
  const names = ['Pulse.Auth.Cookie', '.AspNetCore.Cookies'];
  final parts = names.any(cookie.startsWith)
      ? cookie.split(';')
      : ['.AspNetCore.Cookies=$cookie'];
  for (final part in parts) {
    final normalized = part.trim();
    final separator = normalized.indexOf('=');
    if (separator < 1) throw const FormatException('Invalid session cookie.');
    final name = normalized.substring(0, separator);
    final value = normalized.substring(separator + 1);
    if (!RegExp(r'^(?:Pulse\.Auth\.Cookie|\.AspNetCore\.Cookies)(?:C[1-9][0-9]*)?$')
            .hasMatch(name) ||
        cookies.containsKey(name) ||
        value.isEmpty ||
        value.codeUnits.any(
          (byte) =>
              byte < 0x21 ||
              byte > 0x7e ||
              const [0x22, 0x2c, 0x3b, 0x5c].contains(byte),
        ) ||
        part.contains('\r') ||
        part.contains('\n')) {
      throw const FormatException('Invalid session cookie.');
    }
    cookies[name] = value;
  }
  final name = names.where(cookies.containsKey).firstOrNull;
  if (name == null) throw const FormatException('Missing session cookie.');
  final base = cookies[name]!;
  final chunked = base.startsWith('chunks-');
  if (chunked && !RegExp(r'^chunks-[1-9][0-9]*$').hasMatch(base)) {
    throw const FormatException('Invalid chunked session cookie.');
  }
  final count = chunked ? int.tryParse(base.substring('chunks-'.length)) : 0;
  final family = RegExp('^${RegExp.escape(name)}(?:C[1-9][0-9]*)?\$');
  final familyCount = cookies.keys.where(family.hasMatch).length;
  if (count == null || count < 0 || count > 64 || familyCount != count + 1) {
    throw const FormatException('Incomplete session cookie.');
  }
  final entries = ['$name=$base'];
  for (var index = 1; index <= count; index++) {
    final chunkName = '${name}C$index';
    final chunk = cookies[chunkName];
    if (chunk == null) {
      throw const FormatException('Incomplete session cookie.');
    }
    entries.add('$chunkName=$chunk');
  }
  return entries.join('; ');
}
