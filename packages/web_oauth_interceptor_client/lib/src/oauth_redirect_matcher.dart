class OAuthRedirectMatcher {
  const OAuthRedirectMatcher._();

  static bool matches(String candidateUrl, Iterable<String> expectedUrls) {
    final candidate = Uri.tryParse(candidateUrl);
    if (candidate == null) return false;

    return expectedUrls.any((expectedUrl) {
      final expected = Uri.tryParse(expectedUrl);
      if (expected == null) return false;

      return candidate.scheme == expected.scheme &&
          candidate.host == expected.host &&
          candidate.port == expected.port &&
          candidate.path == expected.path &&
          expected.queryParameters.entries.every(
            (entry) => candidate.queryParameters[entry.key] == entry.value,
          );
    });
  }
}
