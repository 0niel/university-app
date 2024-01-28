import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that adaptively displays a [ListTile] on Material platforms
/// and a [CupertinoListTile] on Cupertino ones.
class AdaptiveListTile extends StatelessWidget {
  /// Creates a new adaptive list tile.
  ///
  /// If supplied the [subtitle] will be displayed below the title.
  const AdaptiveListTile({
    required this.title,
    this.enabled = true,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  }) : additionalInfo = null;

  /// Creates a new adaptive list tile.
  ///
  /// If supplied the [additionalInfo] will be displayed below the title on
  /// Material platforms and as a trailing widget on Cupertino ones.
  const AdaptiveListTile.additionalInfo({
    required this.title,
    this.enabled = true,
    this.additionalInfo,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  }) : subtitle = additionalInfo;

  /// {@template neon_framework.AdaptiveListTile.title}
  /// A [title] is used to convey the central information. Usually a [Text].
  /// {@endtemplate}
  final Widget title;

  /// {@template neon_framework.AdaptiveListTile.subtitle}
  /// A [subtitle] is used to display additional information. It is located
  /// below [title]. Usually a [Text] widget.
  /// {@endtemplate}
  final Widget? subtitle;

  /// {@template neon_framework.AdaptiveListTile.additionalInfo}
  /// Similar to [subtitle], an [additionalInfo] is used to display additional
  /// information. However, instead of being displayed below [title], it is
  /// displayed on the right, before [trailing]. Usually a [Text] widget.
  ///
  /// This is only available on Cupertino platforms.
  /// {@endtemplate}
  final Widget? additionalInfo;

  /// {@template neon_framework.AdaptiveListTile.leading}
  /// A widget displayed at the start of the [AdaptiveListTile]. This is
  /// typically an `Icon` or an `Image`.
  /// {@endtemplate}
  final Widget? leading;

  /// {@template neon_framework.AdaptiveListTile.trailing}
  /// A widget displayed at the end of the [AdaptiveListTile].
  /// {@endtemplate}
  final Widget? trailing;

  /// {@template neon_framework.AdaptiveListTile.onTap}
  /// The [onTap] function is called when a user taps on the[AdaptiveListTile].
  /// If left `null`, the [AdaptiveListTile] will not react to taps.
  ///
  /// If the platform is a Cupertino one and this is a `Future<void> Function()`,
  /// then the [AdaptiveListTile] remains activated until the returned future is
  /// awaited. This is according to iOS behavior.
  /// However, if this function is a `void Function()`, then the tile is active
  /// only for the duration of invocation.
  /// {@endtemplate}
  final FutureOr<void> Function()? onTap;

  /// {@template neon_framework.AdaptiveListTile.enabled}
  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] callback is inoperative.
  /// {@endtemplate}
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return ListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onTap: onTap,
          enabled: enabled,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final tile = CupertinoListTile(
          title: title,
          subtitle: additionalInfo == null ? subtitle : null,
          additionalInfo: additionalInfo,
          leading: leading,
          trailing: trailing,
          onTap: enabled ? onTap : null,
        );

        if (!enabled) {
          var data = CupertinoTheme.of(context);
          data = data.copyWith(
            textTheme: data.resolveFrom(context).textTheme.copyWith(
                  textStyle: data.textTheme.textStyle.merge(
                    TextStyle(
                      color: theme.disabledColor,
                    ),
                  ),
                ),
          );

          return CupertinoTheme(
            data: data,
            child: tile,
          );
        }

        return tile;
    }
  }
}
