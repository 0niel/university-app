Map<String, String>? completeOAuthSessionCookies(
  Map<String, String> cookies,
  String name,
) {
  final value = cookies[name];
  if (value == null || value.isEmpty) return null;
  final chunked = value.startsWith('chunks-');
  if (chunked && !RegExp(r'^chunks-[1-9][0-9]*$').hasMatch(value)) {
    return null;
  }
  final count = chunked ? int.tryParse(value.substring('chunks-'.length)) : 0;
  if (count == null || count > cookies.length) return null;
  for (var index = 1; index <= count; index++) {
    if (cookies['${name}C$index']?.isNotEmpty != true) return null;
  }
  final pattern = RegExp('^${RegExp.escape(name)}' r'C([1-9][0-9]*)$');
  final result = <String, String>{};
  for (final entry in cookies.entries) {
    final match = pattern.firstMatch(entry.key);
    if (match == null ||
        (int.tryParse(match.group(1)!) ?? count + 1) <= count) {
      result[entry.key] = entry.value;
    }
  }
  return result;
}
