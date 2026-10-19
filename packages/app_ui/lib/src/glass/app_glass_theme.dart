import 'package:flutter/material.dart';

@immutable
class AppGlassTheme extends ThemeExtension<AppGlassTheme> {
  const AppGlassTheme({this.enabled = true});

  factory AppGlassTheme.of(BuildContext context) =>
      Theme.of(context).extension<AppGlassTheme>() ?? const AppGlassTheme();

  final bool enabled;

  @override
  AppGlassTheme copyWith({bool? enabled}) =>
      AppGlassTheme(enabled: enabled ?? this.enabled);

  @override
  AppGlassTheme lerp(covariant AppGlassTheme? other, double t) =>
      other == null || t < .5 ? this : other;
}
