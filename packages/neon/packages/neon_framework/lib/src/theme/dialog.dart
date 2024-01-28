import 'package:flutter/material.dart';
import 'package:neon_framework/src/theme/neon.dart';
import 'package:neon_framework/src/widgets/dialog.dart';

/// Defines a theme for [NeonDialog] widgets.
///
/// Descendant widgets obtain the current [NeonDialogTheme] object using
/// `NeonDialogTheme.of(context)`. Instances of [NeonDialogTheme] can be customized with
/// [NeonDialogTheme.copyWith].
@immutable
class NeonDialogTheme {
  /// Creates a dialog theme that can be used for [NeonTheme.dialogTheme].
  const NeonDialogTheme({
    this.constraints = const BoxConstraints(
      minWidth: 280,
      maxWidth: 560,
    ),
    this.padding = const EdgeInsets.all(24),
  });

  /// Used to configure the [BoxConstraints] for the [NeonDialog] widget.
  ///
  /// This value should also be used on [Dialog.fullscreen] and other similar pages.
  /// By default it follows the default [m3 dialog specification](https://m3.material.io/components/dialogs/specs).
  final BoxConstraints constraints;

  /// Padding around the content.
  ///
  /// This property defaults to providing a padding of 24 pixels on all sides
  /// to separate the content from the edges of the dialog.
  final EdgeInsets padding;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  NeonDialogTheme copyWith({
    BoxConstraints? constraints,
    EdgeInsets? padding,
  }) =>
      NeonDialogTheme(
        constraints: constraints ?? this.constraints,
        padding: padding ?? this.padding,
      );

  /// The data from the closest [NeonDialogTheme] instance given the build context.
  static NeonDialogTheme of(BuildContext context) =>
      Theme.of(context).extension<NeonTheme>()?.dialogTheme ?? const NeonDialogTheme();

  /// Linearly interpolate between two [NeonDialogTheme]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  // ignore: prefer_constructors_over_static_methods
  static NeonDialogTheme lerp(NeonDialogTheme a, NeonDialogTheme b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return NeonDialogTheme(
      constraints: BoxConstraints.lerp(a.constraints, b.constraints, t)!,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        constraints,
        padding,
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NeonDialogTheme && other.constraints == constraints && other.padding == padding;
  }
}
