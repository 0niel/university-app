final class DeepLinkClientFailure implements Exception {
  const DeepLinkClientFailure(this.error);

  final Object error;
}
