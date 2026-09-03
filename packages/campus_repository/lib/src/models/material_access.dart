class MaterialAccess {
  const MaterialAccess({required this.canDownload, required this.price});

  factory MaterialAccess.fromJson(Map<String, Object?> json) {
    final canDownload = json['canDownload'];
    final price = json['price'];
    if (canDownload is! bool || price is! int || price < 0 || price > 1000000) {
      throw const FormatException('Invalid material access');
    }
    return MaterialAccess(canDownload: canDownload, price: price);
  }

  final bool canDownload;
  final int price;
}

enum MaterialPurchaseFailure { insufficientBalance, priceChanged, unavailable }

class MaterialPurchaseException implements Exception {
  const MaterialPurchaseException(this.reason);

  final MaterialPurchaseFailure reason;
}
