enum CommunityPlatform { telegram, vk, discord, web }

CommunityPlatform communityPlatformFor(Uri uri) {
  final host = uri.host.toLowerCase();
  if (_matchesHost(host, const {'t.me', 'telegram.me'})) {
    return .telegram;
  }
  if (_matchesHost(host, const {'vk.com', 'vk.ru'})) {
    return .vk;
  }
  if (_matchesHost(host, const {'discord.com', 'discord.gg'})) {
    return .discord;
  }
  return .web;
}

Uri? safeCommunityUri(String? value) {
  if (value == null) return null;
  final uri = Uri.tryParse(value);
  if (uri == null ||
      uri.scheme.toLowerCase() != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    return null;
  }
  return uri;
}

bool _matchesHost(String host, Set<String> allowedHosts) => allowedHosts.any(
  (allowedHost) => host == allowedHost || host.endsWith('.$allowedHost'),
);
