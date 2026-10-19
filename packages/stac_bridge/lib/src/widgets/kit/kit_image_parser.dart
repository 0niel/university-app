import 'package:flutter/material.dart';

export 'kit_network_image.dart';
export 'stac_app_image_parser.dart';

BoxFit boxFitOf(String? name) => switch (name) {
  'contain' => .contain,
  'fill' => .fill,
  'fitWidth' => .fitWidth,
  'fitHeight' => .fitHeight,
  'none' => .none,
  'scaleDown' => .scaleDown,
  _ => .cover,
};
