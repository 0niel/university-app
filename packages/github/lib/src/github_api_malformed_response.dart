class GithubApiMalformedResponse implements Exception {
  const GithubApiMalformedResponse({required this.error});

  final Object error;

  @override
  String toString() => 'GithubApiMalformedResponse: $error';
}
