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
import 'dart:ui' as ui;

import 'package:app_ui/src/glass/app_glass_lite_outline.dart';
import 'package:flutter/painting.dart';

class AppGlassLiteMesh {
  const AppGlassLiteMesh._({
    required this.path,
    required this.vertices,
    required this.vertexCount,
    required this.triangleCount,
    required this.byteSize,
  });

  final Path path;
  final ui.Vertices vertices;
  final int vertexCount;
  final int triangleCount;
  final int byteSize;

  static const _depth = 1.5;
  static const double _shift = -.6 + .22;
  static const _inset = .167;
  static const double _arcGain = 1.2 * .45 * .1;
  static const double _arcPower = .1 + (1.0 - .9) * 2;
  static const _steps = [.94, .87, .79, .70, .58, .42, .0];

  static AppGlassLiteMesh? build({
    required Size size,
    required double radius,
    required double borderAlpha,
  }) {
    if (!size.isFinite || size.isEmpty || !radius.isFinite || radius < 0) {
      return null;
    }
    if (!borderAlpha.isFinite || borderAlpha <= 0) return null;
    final outline = AppGlassLiteOutline.build(size, radius);
    if (outline == null) return null;
    final arcs = _arcs(outline);
    final rings = _rings();
    final ramps = [for (final distance in rings) _ramp(distance)];
    final alpha = borderAlpha.clamp(.0, 1.0);
    final largestArc = arcs.reduce(math.max);
    var ringCount = 0;
    for (var index = 0; index < rings.length; index++) {
      if (_alphaAt(largestArc * ramps[index], alpha) != 0) {
        ringCount = math.min(index + 2, rings.length);
      }
    }
    if (ringCount == 0) return null;
    final vertexCount = outline.count * ringCount;
    final positions = Float32List(vertexCount * 2);
    final colors = Int32List(vertexCount);
    final maxInward = .45 * math.min(size.width, size.height);
    for (var ring = 0; ring < ringCount; ring++) {
      final distance = math.max(rings[ring], -maxInward);
      for (var sample = 0; sample < outline.count; sample++) {
        final vertex = ring * outline.count + sample;
        positions[vertex * 2] =
            outline.x[sample] + outline.normalX[sample] * distance;
        positions[vertex * 2 + 1] =
            outline.y[sample] + outline.normalY[sample] * distance;
        colors[vertex] =
            (_alphaAt(arcs[sample] * ramps[ring], alpha) << 24) | 0x00ffffff;
      }
    }
    final indices = Uint16List(outline.count * (ringCount - 1) * 6);
    final indexCount = _indices(outline.count, ringCount, colors, indices);
    if (indexCount == 0) return null;
    return AppGlassLiteMesh._(
      path: outline.path,
      vertices: ui.Vertices.raw(
        ui.VertexMode.triangles,
        positions,
        colors: colors,
        indices: Uint16List.sublistView(indices, 0, indexCount),
      ),
      vertexCount: vertexCount,
      triangleCount: indexCount ~/ 3,
      byteSize: positions.lengthInBytes + colors.lengthInBytes + indexCount * 2,
    );
  }

  static Float64List _arcs(AppGlassLiteOutline outline) {
    const angle = 39.0 * math.pi / 180;
    final lightX = math.cos(angle);
    final lightY = math.sin(angle);
    final arcs = Float64List(outline.count);
    for (var index = 0; index < outline.count; index++) {
      final direction =
          outline.normalX[index] * lightX + outline.normalY[index] * lightY;
      arcs[index] = math
          .pow(
            math.max(direction * direction * 1.0 * _arcGain, 1e-6),
            _arcPower,
          )
          .toDouble()
          .clamp(.0, 1.0);
    }
    return arcs;
  }

  static List<double> _rings() {
    double distanceAt(double ramp) => (ramp - 1.0 - _shift) * _depth - _inset;
    final top = math.min(1.0 + _shift + _inset / _depth, 1);
    return [
      1.0,
      .0,
      if (distanceAt(1) < 0) distanceAt(1),
      for (final step in _steps) distanceAt(top * step),
    ];
  }

  static double _ramp(double distance) {
    final double value = math.max(
      1.0 + _shift + (distance + _inset) / _depth,
      0,
    );
    final squared = value * value;
    return (squared * squared * value).clamp(.0, 1.0);
  }

  static int _alphaAt(double strength, double alpha) {
    final weight = (strength * 6).clamp(.0, 1.0) * alpha;
    final opacity = weight * (1.5 * strength).clamp(.0, 1.0);
    return (opacity.clamp(.0, 1.0) * 255).round();
  }

  static int _indices(
    int samples,
    int rings,
    Int32List colors,
    Uint16List indices,
  ) {
    var count = 0;
    void append(int first, int second, int third) {
      if (((colors[first] | colors[second] | colors[third]) & 0xff000000) ==
          0) {
        return;
      }
      indices[count++] = first;
      indices[count++] = second;
      indices[count++] = third;
    }

    for (var ring = 0; ring < rings - 1; ring++) {
      final inner = ring * samples;
      final outer = inner + samples;
      for (var index = 0; index < samples; index++) {
        final next = index + 1 == samples ? 0 : index + 1;
        append(inner + index, inner + next, outer + index);
        append(inner + next, outer + next, outer + index);
      }
    }
    return count;
  }
}
