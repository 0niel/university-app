import 'package:flutter/material.dart';

/// Returns whether the current platform is a Cupertino one.
///
/// This is true for both `TargetPlatform.iOS` and `TargetPlatform.macOS`.
bool isCupertino(BuildContext context) {
  /// TODO: Create config for this.
  return false;
  // final theme = Theme.of(context);

  // switch (theme.platform) {
  //   case TargetPlatform.android:
  //   case TargetPlatform.fuchsia:
  //   case TargetPlatform.linux:
  //   case TargetPlatform.windows:
  //     return false;
  //   case TargetPlatform.iOS:
  //   case TargetPlatform.macOS:
  //     return true;
  // }
}
