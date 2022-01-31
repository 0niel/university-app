import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

abstract class DarkThemeColors {
  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  static const primary = Color(0xFF246BFD);
  static const secondary = Color(0xFFC25FFF);

  // Backgrounds
  static const background01 = Color(0xFF181A20);
  static const background02 = Color(0xFF262A34);
  static const background03 = Color(0xFF1F222A);

  // Colorful
  static const colorful01 = Color(0xFFA06AF9);
  static const colorful02 = Color(0xFFFBA3FF);
  static const colorful03 = Color(0xFF8E96FF);
  static const colorful04 = Color(0xFF94F0F0);
  static const colorful05 = Color(0xFFA5F59C);
  static const colorful06 = Color(0xFFFFDD72);
  static const colorful07 = Color(0xFFFF968E);

  static const white = Color(0xFFFFFFFF);

  // States
  static const active = white;
  static const deactive = Color(0xFF5E6272);
  static const activeLightMode = Color(0xFF200745);
  static const deactiveDarker = Color(0xFF3A3D46);

  static const gradient07 =
      LinearGradient(colors: [Color(0xFFBBFFE7), Color(0xFF86FFCA)]);
}
