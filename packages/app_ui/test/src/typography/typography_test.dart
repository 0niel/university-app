import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('semantic card typography shares the upright sans family', () {
    for (final style in [
      AppText.identityTitle,
      AppText.cardValue,
      AppText.cardSubtitle,
      AppText.cardDescription,
      AppText.quickActionLabel,
    ]) {
      expect(style.fontFamily, AppText.sansFamily);
      expect(style.fontStyle ?? FontStyle.normal, FontStyle.normal);
      expect(style.fontSize, isPositive);
      expect(style.height, greaterThan(1));
    }
  });

  test('tabular values retain the shared card metrics without mutation', () {
    final value = AppText.tabular(AppText.cardValue);
    expect(value.fontSize, AppText.cardValue.fontSize);
    expect(value.height, AppText.cardValue.height);
    expect(value.letterSpacing, AppText.cardValue.letterSpacing);
    expect(value.fontFeatures, contains(const FontFeature.tabularFigures()));
    expect(AppText.cardValue.fontFeatures, isNull);
  });
}
