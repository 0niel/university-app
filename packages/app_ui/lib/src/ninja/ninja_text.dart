import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';

abstract final class NinjaText {
  static const String family = AppText.sansFamily;
  static const String serifFamily = AppText.serifFamily;

  static final TextStyle display = AppText.displaySmall;

  static final TextStyle title = AppText.title;

  static final TextStyle appBarTitle = AppText.sectionLarge;

  static final TextStyle headline = AppText.headline;

  static final TextStyle dialogTitle =
      AppText.sans(17, FontWeight.w700, height: 1.2);

  static final TextStyle body = AppText.compact.copyWith(
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final TextStyle subtext = AppText.subtext;

  static final TextStyle microLabel = AppText.captionSmall;

  static final TextStyle badge =
      AppText.sans(10.5, FontWeight.w600, height: 1.2);

  static final TextStyle button = AppText.button;

  static final TextStyle buttonLarge = AppText.buttonLarge;

  static final TextStyle buttonSmall = AppText.buttonSmall;

  static final TextStyle helper = AppText.sans(11.5, FontWeight.w500);

  static TextStyle tabular(TextStyle base) => base.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

abstract final class NinjaRadius {
  static const control = 18.0;
  static const button = 999.0;
  static const tile = 14.0;
  static const banner = 16.0;
  static const row = 22.0;
  static const card = 24.0;
  static const hero = 26.0;
  static const dialog = 28.0;
  static const sheet = 32.0;
  static const double pill = button;
}

abstract final class NinjaMetrics {
  static const lineWidth = 1.0;
  static const subjectBarWidth = 4.0;
  static const subjectBarWidthCompact = 4.0;
  static const minTouchTarget = 44.0;
  static const screenPadding = 20.0;
  static const screenTopPadding = 56.0;
}
