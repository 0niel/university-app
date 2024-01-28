import 'package:flutter/material.dart';
import 'package:neon_framework/src/theme/colors.dart';
import 'package:neon_framework/src/theme/neon.dart';

/// A ColorScheme used in the [NeonTheme].
@immutable
class NeonColorScheme {
  /// Creates a new Neon color scheme.
  const NeonColorScheme({
    this.primary = NcColors.primary,
  });

  /// Primary color used throughout the app.
  ///
  /// See [ColorScheme.primary]
  final Color primary;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  NeonColorScheme copyWith({
    Color? primary,
    Color? oledBackground,
  }) =>
      NeonColorScheme(
        primary: primary ?? this.primary,
      );

  /// The data from the closest [NeonColorScheme] instance given the build context.
  static NeonColorScheme of(BuildContext context) => Theme.of(context).extension<NeonTheme>()!.colorScheme;

  /// Linearly interpolate between two [NeonColorScheme]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  // ignore: prefer_constructors_over_static_methods
  static NeonColorScheme lerp(NeonColorScheme a, NeonColorScheme b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return NeonColorScheme(
      primary: Color.lerp(a.primary, b.primary, t)!,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        primary,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NeonColorScheme && other.primary == primary;
  }
}
