/// Thrown when Discourse returns a non-successful HTTP status.
class DiscourseApiRequestFailure implements Exception {
  const DiscourseApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final Map<String, dynamic> body;

  @override
  String toString() => 'Discourse API request failed ($statusCode): $body';
}
