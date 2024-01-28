import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ThemeColors {
  ThemeColors();

  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  Color get primary => const Color(0xFF246BFD);
  Color get secondary => const Color(0xFFC25FFF);

  // Backgrounds
  Color get background01 => const Color(0xFF181A20);
  Color get background02 => const Color(0xFF262A34);
  Color get background03 => const Color(0xFF1F222A);

  // Colorful
  Color get colorful01 => const Color(0xFFA06AF9);
  Color get colorful02 => const Color(0xFFFBA3FF);
  Color get colorful03 => const Color(0xFF8E96FF);
  Color get colorful04 => const Color(0xFF94F0F0);
  Color get colorful05 => const Color(0xFFA5F59C);
  Color get colorful06 => const Color(0xFFFFDD72);
  Color get colorful07 => const Color(0xFFFF968E);

  Color get white => const Color(0xFFFFFFFF);

  // States
  Color get active => const Color(0xFFFFFFFF);
  Color get deactive => const Color(0xFF5E6272);
  Color get activeLightMode => const Color(0xFF200745);
  Color get deactiveDarker => const Color(0xFF3A3D46);

  LinearGradient get gradient07 => const LinearGradient(colors: [Color(0xFFBBFFE7), Color(0xFF86FFCA)]);
}

class LightThemeColors extends ThemeColors {
  LightThemeColors();

  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  @override
  Color get primary => const Color(0xFF246BFD);
  @override
  Color get secondary => const Color(0xFFC25FFF);

  // Backgrounds
  @override
  Color get background01 => const Color(0xFFF5F5F5);
  @override
  Color get background02 => const Color(0xFFFFFFFF);
  @override
  Color get background03 => const Color(0xFFF8F8F8);

  // Colorful
  @override
  Color get colorful01 => const Color(0xFFA06AF9);
  @override
  Color get colorful02 => const Color(0xFFFBA3FF);
  @override
  Color get colorful03 => const Color(0xFF8E96FF);
  @override
  Color get colorful04 => const Color(0xFF94F0F0);
  @override
  Color get colorful05 => const Color(0xFF5DCD9B);
  @override
  Color get colorful06 => const Color(0xFFFFDD72);
  @override
  Color get colorful07 => const Color(0xFFFF968E);

  @override
  Color get white => const Color(0xFFFFFFFF);

  // States
  @override
  Color get active => const Color(0xFF0D0D0D);
  @override
  Color get deactive => const Color(0xFF5E6272);
  @override
  Color get activeLightMode => const Color(0xFF200745);
  @override
  Color get deactiveDarker => const Color(0xFF3A3D46);

  @override
  LinearGradient get gradient07 => const LinearGradient(colors: [Color(0xFFBBFFE7), Color(0xFF86FFCA)]);
}

class AmoledDarkThemeColors extends ThemeColors {
  AmoledDarkThemeColors();

  // Primary actions, emphasizing navigation elements,
  // backgrounds, text, etc.
  @override
  Color get primary => const Color(0xFF246BFD);
  @override
  Color get secondary => const Color(0xFFC25FFF);

  // Backgrounds
  @override
  Color get background01 => const Color(0xFF000000);
  @override
  Color get background02 => const Color(0xFF000000);
  @override
  Color get background03 => const Color(0xFF000000);

  // Colorful
  @override
  Color get colorful01 => const Color(0xFFA06AF9);
  @override
  Color get colorful02 => const Color(0xFFFBA3FF);
  @override
  Color get colorful03 => const Color(0xFF8E96FF);
  @override
  Color get colorful04 => const Color(0xFF94F0F0);
  @override
  Color get colorful05 => const Color(0xFFA5F59C);
  @override
  Color get colorful06 => const Color(0xFFFFDD72);
  @override
  Color get colorful07 => const Color(0xFFFF968E);

  @override
  Color get white => const Color(0xFFFFFFFF);

  // States
  @override
  Color get active => const Color(0xFFE5E5E5);
  @override
  Color get deactive => const Color(0xFF5E6272);
  @override
  Color get activeLightMode => const Color(0xFF200745);
  @override
  Color get deactiveDarker => const Color(0xFF3A3D46);

  @override
  LinearGradient get gradient07 => const LinearGradient(colors: [Color(0xFFBBFFE7), Color(0xFF86FFCA)]);
}
