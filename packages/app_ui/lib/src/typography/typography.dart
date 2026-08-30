import 'package:app_ui/src/generated/generated.dart';
import 'package:flutter/material.dart';

abstract final class AppText {
  static const _base = TextStyle(
    fontFamily: FontFamily.inter,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle displayHero = _base.copyWith(
    fontSize: 27,
    height: 1.1,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle displayLarge = _base.copyWith(
    fontSize: 30,
    height: 1.1,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle display = _base.copyWith(
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle displaySmall = _base.copyWith(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle title = _base.copyWith(
    fontSize: 19,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle heading = _base.copyWith(
    fontSize: 15.5,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = _base.copyWith(
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyStrong =
      body.copyWith(fontWeight: FontWeight.w700);

  static final TextStyle bodyLarge = body.copyWith(fontSize: 15);

  static final TextStyle bodyRegular =
      body.copyWith(fontWeight: FontWeight.w400);

  static final TextStyle caption = _base.copyWith(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle captionSmall = _base.copyWith(
    fontSize: 11,
    height: 1.25,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle button = _base.copyWith(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle buttonLarge = button.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle tab = button;

  static final TextStyle overline = _base.copyWith(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: .8,
  );

  static final TextStyle chip = _base.copyWith(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tabular([TextStyle? base]) {
    return (base ?? bodyStrong).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
