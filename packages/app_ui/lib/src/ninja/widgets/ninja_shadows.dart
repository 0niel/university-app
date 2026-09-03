import 'package:flutter/material.dart';

abstract final class NinjaShadows {
  static const List<BoxShadow> none = <BoxShadow>[];

  static List<BoxShadow> glow(Color color, {double alpha = 0}) => none;

  static const List<BoxShadow> fab = none;

  static const List<BoxShadow> segment = none;

  static const List<BoxShadow> knob = none;
}
