import 'package:flutter/material.dart';

abstract final class NinjaShadows {
  static List<BoxShadow> glow(Color color, {double alpha = 0.08}) => [
        BoxShadow(color: color.withValues(alpha: alpha), spreadRadius: 3),
      ];
  static const fab = [
    BoxShadow(
      color: Color(0x40101014),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
  static const segment = [
    BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 1)),
  ];
  static const knob = [
    BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1)),
  ];
}
