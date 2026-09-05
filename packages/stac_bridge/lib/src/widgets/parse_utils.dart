import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';

typedef KitModel = Map<String, dynamic>;

Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  final value = hex.replaceFirst('#', '');
  final digits = value.length == 6 ? 'FF$value' : value;
  if (digits.length != 8) return null;
  final parsed = int.tryParse(digits, radix: 16);
  return parsed == null ? null : Color(parsed);
}

Color? parseAppColor(BuildContext context, String? value) {
  if (value == null) return null;
  final colors = context.colors;
  return switch (value) {
    'accent' => colors.accent,
    'accentPressed' => colors.accentPressed,
    'onAccent' => colors.onAccent,
    'ink' => colors.ink,
    'muted' => colors.muted,
    'muted2' => colors.muted2,
    'surface' => colors.surface,
    'surface2' => colors.surface2,
    'canvas' => colors.canvas,
    'line' => colors.line,
    'lecture' => colors.lecture,
    'practice' => colors.practice,
    'lab' => colors.lab,
    'exam' => colors.exam,
    'warn' => colors.warn,
    'danger' => colors.danger,
    'success' => colors.success,
    'white' => colors.white,
    'scrim' => colors.scrim,
    'tint' || 'accentTint' => colors.tint,
    'tint2' => colors.tint2,
    'lectureTint' => colors.lectureTint,
    'practiceTint' => colors.practiceTint,
    'labTint' => colors.labTint,
    'examTint' => colors.examTint,
    'warnTint' => colors.warnTint,
    'dangerTint' => colors.dangerTint,
    'successTint' => colors.successTint,
    'inkTint' => colors.tintOf(colors.ink),
    'mutedTint' => colors.tintOf(colors.muted),
    _ => parseHexColor(value),
  };
}

Color? colorOf(BuildContext context, KitModel model, String key) {
  final value = model[key];
  return value is String ? parseAppColor(context, value) : null;
}

VoidCallback? actionCallback(BuildContext context, Object? actionJson) {
  if (actionJson is! Map<Object?, Object?>) return null;
  final json = Map<String, Object?>.from(actionJson);
  return () => runMiniAppAction(context, json);
}

VoidCallback? actionOf(
  BuildContext context,
  KitModel model,
  List<String> keys,
) {
  for (final key in keys) {
    final callback = actionCallback(context, model[key]);
    if (callback != null) return callback;
  }
  return null;
}

Widget? childWidget(BuildContext context, Object? childJson) {
  if (childJson is! Map<Object?, Object?>) return null;
  return Stac.fromJson(Map<String, Object?>.from(childJson), context);
}

List<Widget> childrenWidgets(BuildContext context, Object? childrenJson) {
  if (childrenJson is! List<Object?>) return const [];
  return [for (final child in childrenJson) ?childWidget(context, child)];
}

String stringOf(Map<String, Object?> json, String key, [String fallback = '']) {
  final value = json[key];
  return value is String ? value : fallback;
}

String? stringOrNullOf(Map<String, Object?> json, String key) {
  final value = json[key];
  return value is String ? value : null;
}

bool boolOf(Map<String, Object?> json, String key, {bool fallback = false}) {
  final value = json[key];
  if (value is bool) return value;
  if (value is String) return value == 'true';
  return fallback;
}

double? doubleOf(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  return value is String ? double.tryParse(value) : null;
}

double doubleOr(Map<String, Object?> json, String key, double fallback) =>
    doubleOf(json, key) ?? fallback;

int? intOf(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num) return value.toInt();
  return value is String ? int.tryParse(value) : null;
}

List<String> stringListOf(Map<String, Object?> json, String key) {
  final value = json[key];
  return value is List<Object?>
      ? value.map((item) => item?.toString() ?? '').toList()
      : const [];
}

List<KitModel> mapListOf(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List<Object?>) return const [];
  return value.whereType<Map<Object?, Object?>>().map(KitModel.from).toList();
}

AppLineIcon? appLineIconByName(String? name) {
  for (final icon in AppLineIcon.values) {
    if (icon.name == name) return icon;
  }
  return null;
}

AppLineIcon? iconOf(Map<String, Object?> json, String key) =>
    appLineIconByName(stringOrNullOf(json, key));

T enumByName<T extends Enum>(List<T> values, String? name, T fallback) =>
    values.firstWhereOrNull((value) => value.name == name) ?? fallback;

String labelOf(Object? node) {
  if (node is String) return node;
  if (node is! Map<Object?, Object?>) return '';
  for (final key in const ['data', 'label', 'text', 'title', 'message']) {
    final value = node[key];
    if (value is String) return value;
    if (value is Map<Object?, Object?>) {
      final nested = labelOf(value);
      if (nested.isNotEmpty) return nested;
    }
  }
  final child = node['child'];
  if (child != null) return labelOf(child);
  final children = node['children'];
  if (children is List<Object?>) {
    for (final item in children) {
      final nested = labelOf(item);
      if (nested.isNotEmpty) return nested;
    }
  }
  return '';
}

EdgeInsets insetsOf(Map<String, Object?> json, String key, double fallback) {
  final value = json[key];
  if (value is num) return EdgeInsets.all(value.toDouble());
  if (value is Map<Object?, Object?>) {
    final map = KitModel.from(value);
    final all = doubleOf(map, 'all');
    if (all != null) return EdgeInsets.all(all);
    final horizontal = doubleOf(map, 'horizontal');
    final vertical = doubleOf(map, 'vertical');
    return EdgeInsets.only(
      left: doubleOf(map, 'left') ?? horizontal ?? 0,
      right: doubleOf(map, 'right') ?? horizontal ?? 0,
      top: doubleOf(map, 'top') ?? vertical ?? 0,
      bottom: doubleOf(map, 'bottom') ?? vertical ?? 0,
    );
  }
  return EdgeInsets.all(fallback);
}

String kitText(
  BuildContext context, {
  required String ru,
  required String en,
}) => Localizations.maybeLocaleOf(context)?.languageCode == 'en' ? en : ru;

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
