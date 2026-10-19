import 'package:flutter/material.dart';

export 'kit_input_field.dart';
export 'stac_app_input_field_parser.dart';
export 'stac_app_search_field_parser.dart';

TextInputType? keyboardTypeOf(String? name) => switch (name) {
  'email' || 'emailAddress' => .emailAddress,
  'number' || 'numeric' => .number,
  'phone' => .phone,
  'url' => .url,
  'multiline' => .multiline,
  'text' => .text,
  _ => null,
};
