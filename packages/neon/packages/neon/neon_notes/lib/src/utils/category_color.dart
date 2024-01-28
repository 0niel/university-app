import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/painting.dart';
import 'package:neon_framework/utils.dart';

class NotesCategoryColor {
  const NotesCategoryColor._();

  static final Map<String, Color> _colors = {};

  static Color compute(String category) {
    if (_colors.containsKey(category)) {
      return _colors[category]!;
    }

    final color = HexColor(sha1.convert(utf8.encode(category)).toString().substring(0, 6));
    _colors[category] = color;
    return color;
  }
}
