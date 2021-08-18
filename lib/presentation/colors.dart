import 'dart:ui';

<<<<<<< HEAD
class LightThemeColors {
  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  static final primary801 = Color(0xFF093269);
  static final primary601 = Color(0xFF1264D1);

  /// Active states, primary buttons
  static final primary501 = Color(0xFF2F80ED);
  static final primary201 = Color(0xFFACCCF8);
  static final primary101 = Color(0xFFD5E6FB);

  // Neutral - Text, backgrounds, panels, form controls.
  /// Text color
  static final grey800 = Color(0xFF323F4B);

  /// Dividers, icons, disabled text
  static final grey400 = Color(0xFF7B8794);
  static final grey200 = Color(0xFFCBD2D9);

  /// Disabled buttons
  static final grey100 = Color(0xFFE4E7EB);

  /// Secondary surfaces
  static final grey00 = Color(0xFFF5F7FA);

  /// Primary surfaces, text on dark surface
  static final white = Color(0xFFFFFFFF);

  // Use these for indicating alert states, success indicators
  // and other states where the primary color does not fit.
  static final warning600 = Color(0xFF775E0D);
  static final warning400 = Color(0xFFE7B820);
  static final warning200 = Color(0xFFF3DB90);
  static final warning100 = Color(0xFFF9EDC7);

  static final negative600 = Color(0xFF8D0909);
  static final negative400 = Color(0xFFe02b2b);
  static final negative200 = Color(0xFFF99C9C);
  static final negative100 = Color(0xFFFCCECE);

  static final positive600 = Color(0xFF1A6234);
  static final positive400 = Color(0xFF34C369);
  static final positive200 = Color(0xFF97E3B3);
  static final positive100 = Color(0xFFCBF1D9);
=======
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DarkThemeColors {
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

  static final gradient07 =
      LinearGradient(colors: [Color(0xFFBBFFE7), Color(0xFF86FFCA)]);
>>>>>>> 47bac42 (Update News. (New version))
}
