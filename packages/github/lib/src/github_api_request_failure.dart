class GithubApiRequestFailure implements Exception {
  const GithubApiRequestFailure({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  String toString() => 'GithubApiRequestFailure($statusCode): $body';
}
