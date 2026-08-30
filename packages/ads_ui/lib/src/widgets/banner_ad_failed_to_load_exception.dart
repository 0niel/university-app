class BannerAdFailedToLoadException implements Exception {
  const BannerAdFailedToLoadException(this.error);

  final Object error;
}
