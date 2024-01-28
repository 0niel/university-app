class OpenAPISpecError extends Error {
  OpenAPISpecError(this.message);

  final String message;

  @override
  String toString() => 'Invalid spec: $message.';
}
