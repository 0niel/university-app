import 'package:flutter/material.dart';
import 'package:nextcloud/core.dart' as core;

/// Defines the server configured theme.
@immutable
class ServerTheme extends ThemeExtension<ServerTheme> {
  /// Create a [ServerTheme] that's used to configure a [Theme].
  const ServerTheme({
    required this.nextcloudTheme,
  });

  /// The theme that is configured on the server.
  final core.ThemingPublicCapabilities_Theming? nextcloudTheme;

  @override
  ServerTheme copyWith({
    core.ThemingPublicCapabilities_Theming? nextcloudTheme,
  }) =>
      ServerTheme(
        nextcloudTheme: nextcloudTheme,
      );

  @override
  ServerTheme lerp(ServerTheme? other, double t) {
    if (other is! ServerTheme) {
      return this;
    }

    return ServerTheme(
      nextcloudTheme: nextcloudTheme,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        nextcloudTheme,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ServerTheme && other.nextcloudTheme == nextcloudTheme;
  }
}
