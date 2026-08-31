import 'package:app_ui/src/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

abstract final class NinjaText {
  static const String family = FontFamily.inter;

  static const display = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 1.12,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const title = TextStyle(
    fontFamily: family,
    fontSize: 19,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const appBarTitle = TextStyle(
    fontFamily: family,
    fontSize: 20,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const headline = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static const dialogTitle = TextStyle(
    fontFamily: family,
    fontSize: 17,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  static const body = TextStyle(
    fontFamily: family,
    fontSize: 13.5,
    height: 1.4,
    fontWeight: FontWeight.w500,
  );

  static const subtext = TextStyle(
    fontFamily: family,
    fontSize: 12.5,
    height: 1.35,
    fontWeight: FontWeight.w500,
  );

  static const microLabel = TextStyle(
    fontFamily: family,
    fontSize: 11.5,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static const badge = TextStyle(
    fontFamily: family,
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const button = TextStyle(
    fontFamily: family,
    fontSize: 13.5,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const buttonLarge = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const buttonSmall = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const helper = TextStyle(
    fontFamily: family,
    fontSize: 11.5,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tabular(TextStyle base) => base.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

abstract final class NinjaRadius {
  static const control = 18.0;
  static const button = 999.0;
  static const card = 24.0;
  static const dialog = 28.0;
  static const sheet = 32.0;
  static const double pill = button;
}

abstract final class NinjaMetrics {
  static const lineWidth = 1.0;
  static const subjectBarWidth = 5.0;
  static const subjectBarWidthCompact = 4.0;
  static const minTouchTarget = 44.0;
  static const screenPadding = 20.0;
}
