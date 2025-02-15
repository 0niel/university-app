/// [GoogleAdSizes] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
class GoogleAdSizes {
  /// Constructs an [GoogleAdSizes] with the given [width] and [height].
  const GoogleAdSizes({
    required this.width,
    required this.height,
  });

  /// The vertical span of an ad.
  final int height;

  /// The horizontal span of an ad.
  final int width;

  /// The standard banner (320x50) size.
  static const GoogleAdSizes banner = GoogleAdSizes(width: 320, height: 50);

  /// The large banner (320x100) size.
  static const GoogleAdSizes largeBanner = GoogleAdSizes(width: 320, height: 100);

  /// The medium rectangle (300x250) size.
  static const GoogleAdSizes mediumRectangle = GoogleAdSizes(width: 300, height: 250);

  /// The full banner (468x60) size.
  static const GoogleAdSizes fullBanner = GoogleAdSizes(width: 468, height: 60);

  /// The leaderboard (728x90) size.
  static const GoogleAdSizes leaderboard = GoogleAdSizes(width: 728, height: 90);
}
