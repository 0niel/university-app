import 'package:app_ui/src/generated/generated.dart';
import 'package:flutter/material.dart';

abstract final class AppText {
  static const String sansFamily = 'packages/app_ui/${FontFamily.onest}';
  static const String serifFamily = 'packages/app_ui/${FontFamily.literata}';

  static const TextStyle _sansBase = TextStyle(
    fontFamily: sansFamily,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );

  static const TextStyle _serifBase = TextStyle(
    fontFamily: serifFamily,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );

  static TextStyle sans(
    double size,
    FontWeight weight, {
    double height = 1.3,
    double letterSpacingEm = 0,
    bool tabular = false,
  }) {
    return _sansBase.copyWith(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * letterSpacingEm,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }

  static TextStyle serif(
    double size, {
    double height = 1.15,
    double letterSpacingEm = 0,
    bool italic = false,
  }) {
    return _serifBase.copyWith(
      fontSize: size,
      height: height,
      letterSpacing: size * letterSpacingEm,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      fontVariations: [FontVariation('opsz', size.clamp(7, 72).toDouble())],
    );
  }

  static final TextStyle displayLarge =
      serif(42, height: 1.05, letterSpacingEm: -.02);

  static final TextStyle displayHero =
      serif(36, height: 1.08, letterSpacingEm: -.02);

  static final TextStyle display =
      serif(34, height: 1.05, letterSpacingEm: -.02);

  static final TextStyle displayMedium =
      serif(32, height: 1.08, letterSpacingEm: -.02);

  static final TextStyle displayCompact =
      serif(30, height: 1.12, letterSpacingEm: -.02);

  static final TextStyle displaySmall =
      serif(28, height: 1.05, letterSpacingEm: -.02);

  static final TextStyle sectionLarge = serif(24, height: 1.1);

  static final TextStyle section = serif(22);

  static final TextStyle sectionSmall = serif(19);

  static final TextStyle title =
      sans(19, FontWeight.w700, height: 1.2, letterSpacingEm: -.01);

  static final TextStyle heading = sans(16, FontWeight.w600, height: 1.25);

  static final TextStyle headline = sans(15, FontWeight.w600, height: 1.25);

  static final TextStyle headlineStrong =
      sans(15, FontWeight.w700, height: 1.25);

  static final TextStyle cell = sans(14.5, FontWeight.w600);

  static final TextStyle body = sans(14, FontWeight.w500, height: 1.4);

  static final TextStyle bodyStrong = sans(14, FontWeight.w600, height: 1.4);

  static final TextStyle bodyBold = sans(14, FontWeight.w700, height: 1.4);

  static final TextStyle bodyLarge = sans(15, FontWeight.w500, height: 1.45);

  static final TextStyle bodyRegular = sans(14, FontWeight.w400, height: 1.4);

  static final TextStyle paragraph = sans(15.5, FontWeight.w400, height: 1.55);

  static final TextStyle lead = sans(16, FontWeight.w500, height: 1.45);

  static final TextStyle compact = sans(13.5, FontWeight.w600);

  static final TextStyle compactStrong = sans(13.5, FontWeight.w700);

  static final TextStyle label = sans(13, FontWeight.w600);

  static final TextStyle labelStrong = sans(13, FontWeight.w700);

  static final TextStyle subtext = sans(12.5, FontWeight.w500, height: 1.35);

  static final TextStyle subtextStrong =
      sans(12.5, FontWeight.w600, height: 1.35);

  static final TextStyle subtextBold =
      sans(12.5, FontWeight.w700, height: 1.35);

  static final TextStyle caption = sans(12, FontWeight.w500);

  static final TextStyle captionStrong = sans(12, FontWeight.w600);

  static final TextStyle captionBold = sans(12, FontWeight.w700);

  static final TextStyle captionSmall =
      sans(11.5, FontWeight.w600, height: 1.25);

  static final TextStyle overline =
      sans(11.5, FontWeight.w700, height: 1.2, letterSpacingEm: .08);

  static final TextStyle micro = sans(11, FontWeight.w700, height: 1.2);

  static final TextStyle microBold = sans(11, FontWeight.w800, height: 1.2);

  static final TextStyle badge = sans(11.5, FontWeight.w600, height: 1.2);

  static final TextStyle countBadge = sans(10, FontWeight.w800, height: 1.2);

  static final TextStyle typeTag =
      sans(10.5, FontWeight.w800, height: 1.2, letterSpacingEm: .06);

  static final TextStyle tileTag =
      sans(9.5, FontWeight.w800, height: 1.2, letterSpacingEm: .04);

  static final TextStyle gridTag =
      sans(8.5, FontWeight.w800, height: 1.2, letterSpacingEm: .04);

  static final TextStyle button = sans(13.5, FontWeight.w600, height: 1.2);

  static final TextStyle buttonSmall = sans(12, FontWeight.w600, height: 1.2);

  static final TextStyle buttonLarge = sans(15, FontWeight.w700, height: 1.2);

  static final TextStyle buttonHero = sans(16, FontWeight.w700, height: 1.2);

  static final TextStyle chip = sans(13, FontWeight.w600);

  static final TextStyle chipStrong = sans(13, FontWeight.w700);

  static final TextStyle segment = sans(13.5, FontWeight.w700, height: 1.2);

  static final TextStyle tab = sans(14, FontWeight.w700, height: 1.2);

  static final TextStyle time =
      sans(14, FontWeight.w700, height: 1.5, tabular: true);

  static final TextStyle timeEnd =
      sans(12, FontWeight.w500, height: 1.5, tabular: true);

  static final TextStyle metric =
      sans(19, FontWeight.w800, height: 1.2, tabular: true);

  static final TextStyle metricLarge =
      sans(22, FontWeight.w800, height: 1.2, tabular: true);

  static final TextStyle code =
      sans(22, FontWeight.w700, height: 1.2, tabular: true);

  static TextStyle tabular([TextStyle? base]) {
    return (base ?? bodyStrong).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
