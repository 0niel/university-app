import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

abstract class DarkThemeColors {
  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  static const primary = const Color(0xFF246BFD);
  static const secondary = const Color(0xFFC25FFF);

  // Backgrounds
  static const background01 = const Color(0xFF181A20);
  static const background02 = const Color(0xFF262A34);
  static const background03 = const Color(0xFF1F222A);

  // Colorful
  static const colorful01 = const Color(0xFFA06AF9);
  static const colorful02 = const Color(0xFFFBA3FF);
  static const colorful03 = const Color(0xFF8E96FF);
  static const colorful04 = const Color(0xFF94F0F0);
  static const colorful05 = const Color(0xFFA5F59C);
  static const colorful06 = const Color(0xFFFFDD72);
  static const colorful07 = const Color(0xFFFF968E);
  static const colorful08 = const Color(0xFF60F352);

  static const white = const Color(0xFFFFFFFF);

  // States
  static const active = white;
  static const deactive = const Color(0xFF5E6272);
  static const activeLightMode = const Color(0xFF200745);
  static const deactiveDarker = const Color(0xFF3A3D46);

  static final gradient07 = LinearGradient(
      colors: [const Color(0xFFBBFFE7), const Color(0xFF86FFCA)]);
}
