import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/models/app_implementation.dart';

/// An icon widget displaying the app icon of a client with an overlay displaying the [unreadCount].
@internal
class NeonAppImplementationIcon extends StatelessWidget {
  /// Creates a new app implementation icon.
  const NeonAppImplementationIcon({
    required this.appImplementation,
    this.unreadCount,
    this.color,
    this.size,
    super.key,
  });

  /// The client for which to build the icon.
  ///
  /// Uses [AppImplementation.buildIcon] for the icon data.
  final AppImplementation appImplementation;

  /// The number of unread notifications.
  final int? unreadCount;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.color].
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [IconTheme]) will be further adjusted by the nearest [IconTheme]'s
  /// [IconThemeData.opacity].
  ///
  /// {@tool snippet}
  /// Typically, a Material Design color will be used, as follows:
  ///
  /// ```dart
  /// Icon(
  ///   Icons.widgets,
  ///   color: Colors.blue.shade400,
  /// )
  /// ```
  /// {@end-tool}
  final Color? color;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.size].
  ///
  /// If this [NeonAppImplementationIcon] is being placed inside an [IconButton],
  /// then use [IconButton.iconSize] instead, so that the [IconButton] can make
  /// the splash area the appropriate size as well. The [IconButton] uses an
  /// [IconTheme] to pass down the size to the [NeonAppImplementationIcon].
  final double? size;

  @override
  Widget build(BuildContext context) {
    final unreadCount = this.unreadCount ?? 0;

    final color = this.color ??
        (unreadCount > 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground);

    final icon = Container(
      margin: const EdgeInsets.all(5),
      child: appImplementation.buildIcon(
        size: size,
        color: color,
      ),
    );

    if (unreadCount == 0) {
      return icon;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        icon,
        Text(
          unreadCount.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
