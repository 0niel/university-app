import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

/// Parses `#RRGGBB` (or `#AARRGGBB`) into a [Color], null when invalid.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  final value = hex.replaceFirst('#', '');
  final digits = value.length == 6 ? 'FF$value' : value;
  if (digits.length != 8) return null;
  final parsed = int.tryParse(digits, radix: 16);
  return parsed == null ? null : Color(parsed);
}

Color? parseAppColor(BuildContext context, String? value) {
  final colors = context.colors;
  return switch (value) {
    'accent' => colors.accent,
    'lecture' => colors.lecture,
    'practice' => colors.practice,
    'lab' => colors.lab,
    'exam' => colors.exam,
    'warn' => colors.warn,
    'ink' => colors.ink,
    'muted' => colors.muted,
    'surface' => colors.surface,
    'canvas' => colors.canvas,
    'tint' => colors.tint,
    _ => parseHexColor(value),
  };
}

/// Wraps an action JSON into a tap callback, null when no action is set.
VoidCallback? actionCallback(BuildContext context, Object? actionJson) {
  if (actionJson is! Map<Object?, Object?>) return null;
  final json = Map<String, Object?>.from(actionJson);
  return () => Stac.onCallFromJson(json, context);
}

/// Renders a nested widget JSON, or null when absent/unparseable.
Widget? childWidget(BuildContext context, Object? childJson) {
  if (childJson is! Map<Object?, Object?>) return null;
  return Stac.fromJson(Map<String, Object?>.from(childJson), context);
}

/// Reads a string field with a fallback.
String stringOf(Map<String, Object?> json, String key, [String fallback = '']) {
  final value = json[key];
  return value is String ? value : fallback;
}

/// Reads a bool field with a fallback.
bool boolOf(Map<String, Object?> json, String key, {bool fallback = false}) {
  final value = json[key];
  return value is bool ? value : fallback;
}

/// Walks a decoded-JSON [root] along a dot [path] (`"data.items.0.title"`),
/// stepping into map keys and numeric list indices. Returns [root] unchanged
/// for an empty path, or null when a segment cannot be resolved.
Object? digJson(Object? root, String path) {
  if (path.isEmpty) return root;
  var current = root;
  for (final segment in path.split('.')) {
    if (segment.isEmpty) continue;
    if (current is Map<Object?, Object?>) {
      current = current[segment];
    } else if (current is List<Object?>) {
      final index = int.tryParse(segment);
      current = index == null ? null : current.elementAtOrNull(index);
    } else {
      return null;
    }
  }
  return current;
}
