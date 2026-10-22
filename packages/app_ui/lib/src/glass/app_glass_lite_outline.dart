// MIT License
//
// Copyright (c) 2025 Ahmed Gamil
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// ignore_for_file: avoid-unsafe-collection-methods

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/painting.dart';

class AppGlassLiteOutline {
  AppGlassLiteOutline._(this.path, this.count)
    : x = Float32List(count),
      y = Float32List(count),
      normalX = Float32List(count),
      normalY = Float32List(count);

  final Path path;
  final int count;
  final Float32List x;
  final Float32List y;
  final Float32List normalX;
  final Float32List normalY;

  static AppGlassLiteOutline? build(Size size, double radius) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final metrics = path.computeMetrics().iterator;
    if (!metrics.moveNext()) return null;
    final metric = metrics.current;
    final length = metric.length;
    if (!length.isFinite || length < 4) return null;
    final count = (length / 1.5).ceil().clamp(32, 1024);
    final outline = AppGlassLiteOutline._(path, count);
    final step = length / count;
    for (var index = 0; index < count; index++) {
      final tangent = metric.getTangentForOffset(index * step);
      if (tangent == null) return null;
      outline.x[index] = tangent.position.dx;
      outline.y[index] = tangent.position.dy;
    }
    outline._sampleNormals(size);
    return outline;
  }

  void _sampleNormals(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    for (var index = 0; index < count; index++) {
      final previous = index == 0 ? count - 1 : index - 1;
      final next = index + 1 == count ? 0 : index + 1;
      var tangentX = x[next] - x[previous];
      var tangentY = y[next] - y[previous];
      final length = math.sqrt(tangentX * tangentX + tangentY * tangentY);
      if (length < 1e-6) {
        tangentX = 1;
        tangentY = 0;
      } else {
        tangentX /= length;
        tangentY /= length;
      }
      var outwardX = tangentY;
      var outwardY = -tangentX;
      if (outwardX * (x[index] - centerX) + outwardY * (y[index] - centerY) <
          0) {
        outwardX = -outwardX;
        outwardY = -outwardY;
      }
      normalX[index] = outwardX;
      normalY[index] = outwardY;
    }
  }
}
