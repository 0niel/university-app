import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BadgeRarity maps known and unknown persisted values', () {
    expect(BadgeRarityX.fromString('rare'), BadgeRarity.rare);
    expect(BadgeRarityX.fromString('epic'), BadgeRarity.epic);
    expect(BadgeRarityX.fromString('legendary'), BadgeRarity.legendary);
    expect(BadgeRarityX.fromString('unsupported'), BadgeRarity.common);
  });
}
