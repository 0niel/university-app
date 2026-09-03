abstract final class MarketplaceLayout {
  static const coverHeight = 110.0;
  static const detailsCoverHeight = 150.0;
  static const cardHeight = 263.0;
  static const oneColumnThreshold = 360.0;
  static const largeTextThreshold = 1.4;
  static const extraHeightPerTextScale = 64.0;

  static double cardExtent(double scale) =>
      cardHeight + extraHeightPerTextScale * (scale - 1).clamp(0, 2);

  static int columns(double width, double scale) =>
      width < oneColumnThreshold || scale > largeTextThreshold ? 1 : 2;
}
