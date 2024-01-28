import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static const _headline = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );

  static const _inter = TextStyle(
    fontFamily: 'Inter',
    letterSpacing: 0,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );

  // When height is non-null, the line height of the span of text will be a
  // multiple of font Size and be exactly fontSize * height logical pixels tall.

  // For example, if want to have height 24.0, with font-size 20.0, we should
  // have height property 1.2
  static final h0 = _headline.copyWith(fontSize: 60, height: 1);
  static final h1 = _headline.copyWith(fontSize: 48, height: 1.1);
  static final h2 = _headline.copyWith(fontSize: 40, height: 1.2);
  static final h3 = _headline.copyWith(fontSize: 36, height: 1.1);
  static final h4 = _headline.copyWith(fontSize: 32, height: 1.3);
  static final h5 = _headline.copyWith(fontSize: 24, height: 1.3);
  static final h6 = _headline.copyWith(fontSize: 20, height: 1.2);
  static final title = _headline.copyWith(fontSize: 18, height: 1.3);

  static final titleM = _inter.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final titleS = _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
  static final buttonL = _inter.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
  static final buttonS = _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static final tab = _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
  static final bodyL = _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final body = _inter.copyWith(fontSize: 13, fontWeight: FontWeight.w500);
  static final bodyBold = _inter.copyWith(fontSize: 14, fontWeight: FontWeight.w700);
  static final bodyRegular = _inter.copyWith(fontSize: 13);
  static final captionL = _inter.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
  static final captionS = _inter.copyWith(fontSize: 11, fontWeight: FontWeight.w500);
  static final chip = _inter.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.50);
}
