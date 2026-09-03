import 'package:flutter/widgets.dart';

final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final RegExp _urlPattern = RegExp(r'^https?://[^\s/$.?#].[^\s]*$');
final RegExp _phonePattern = RegExp(r'^\+?[0-9\s\-()]{6,}$');
final RegExp _alphaPattern = RegExp(r'^[\p{L}]+$', unicode: true);
final RegExp _alphanumericPattern = RegExp(r'^[\p{L}\p{N}]+$', unicode: true);

int? _intOption(Map<String, Object?>? options, String key) {
  final value = options?[key];
  if (value is num) return value.toInt();
  return value is String ? int.tryParse(value) : null;
}

bool isValidEmail(String value) => _emailPattern.hasMatch(value);

bool validateRule(
  String rule,
  String value, {
  Map<String, Object?>? options,
}) {
  final length = value.characters.length;
  switch (rule) {
    case 'isRequired':
      return value.trim().isNotEmpty;
    case 'isLength':
      final min = _intOption(options, 'min') ?? 0;
      final max = _intOption(options, 'max');
      return length >= min && (max == null || length <= max);
    case 'isEmail':
      return isValidEmail(value);
    case 'isNumeric':
      return num.tryParse(value) != null;
    case 'isInt':
      return int.tryParse(value) != null;
    case 'isFloat':
      return double.tryParse(value) != null;
    case 'isURL':
      return _urlPattern.hasMatch(value);
    case 'isPhone':
      return _phonePattern.hasMatch(value);
    case 'isAlpha':
      return _alphaPattern.hasMatch(value);
    case 'isAlphanumeric':
      return _alphanumericPattern.hasMatch(value);
    case 'isLowercase':
      return value == value.toLowerCase();
    case 'isUppercase':
      return value == value.toUpperCase();
    case 'equals':
      return value == (options?['comparison']?.toString() ?? '');
    case 'contains':
      return value.contains(options?['seed']?.toString() ?? '');
    case 'isIn':
      final values = options?['values'];
      return values is List<Object?> &&
          values.any((item) => item?.toString() == value);
    case 'matches':
      final pattern = options?['pattern']?.toString();
      if (pattern == null || pattern.isEmpty) return false;
      try {
        return RegExp(pattern).hasMatch(value);
      } on FormatException {
        return false;
      }
    case 'isStrongPassword':
      final minLength = _intOption(options, 'minLength') ?? 8;
      return length >= minLength &&
          value.contains(RegExp('[a-z]')) &&
          value.contains(RegExp('[A-Z]')) &&
          value.contains(RegExp('[0-9]'));
    default:
      return true;
  }
}
