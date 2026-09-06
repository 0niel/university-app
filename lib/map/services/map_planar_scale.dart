import 'dart:math' as math;

import 'package:flutter/widgets.dart';

double mapPlanarScale(Matrix4 matrix) => math.max(
  math.sqrt(matrix[0] * matrix[0] + matrix[1] * matrix[1]),
  math.sqrt(matrix[4] * matrix[4] + matrix[5] * matrix[5]),
);
