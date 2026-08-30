/// Thrown when a Discourse response cannot be decoded or is missing data.
class DiscourseApiMalformedResponse implements Exception {
  const DiscourseApiMalformedResponse({required this.error});

  final Object error;

  @override
  String toString() => 'Malformed Discourse API response: $error';
}
