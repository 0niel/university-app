final class ShareFailure implements Exception {
  const ShareFailure(this.error);

  final Object error;
}
