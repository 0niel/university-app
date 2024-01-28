import 'package:flutter/material.dart';

/// [Color] constants which represent Nextcloud's
/// [color palette](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#color).
abstract final class NcColors {
  /// Nextcloud blue.
  ///
  /// The default primary color as specified by the [design guidelines](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#primary-color).
  static const Color primary = Color(0xFF0082C9);

  /// Nextcloud success.
  ///
  /// The success color as specified by the [design guidelines](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#status-and-indicators).
  static const Color success = Colors.green;

  /// Nextcloud error.
  ///
  /// The error color as specified by the [design guidelines](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#status-and-indicators).
  static const Color error = Colors.red;

  /// Nextcloud warning.
  ///
  /// The warning color as specified by the [design guidelines](https://docs.nextcloud.com/server/latest/developer_manual/design/foundations.html#status-and-indicators).
  static const Color warning = Colors.orange;

  /// The [ColorScheme.background] color used on OLED devices.
  ///
  /// This color is only used at the users discretion.
  static const Color oledBackground = Colors.black;

  /// Color of a starred item.
  static const Color starredColor = Colors.yellow;

  /// Color used to emphasize declining actions.
  ///
  /// Usually used in conjunction with [NcColors.accept].
  static const Color decline = Colors.red;

  /// Color used to emphasize accepting actions.
  ///
  /// Usually used in conjunction with [NcColors.decline].
  static const Color accept = Colors.green;
}
