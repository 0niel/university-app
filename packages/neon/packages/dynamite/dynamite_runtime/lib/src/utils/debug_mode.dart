// ignore_for_file: do_not_use_environment

import 'package:meta/meta.dart';

/// Copied from the flutter framework.
///
/// See: `https://api.flutter.dev/flutter/foundation/kReleaseMode-constant.html`.
@internal
const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// Copied from the flutter framework.
///
/// See: `https://api.flutter.dev/flutter/foundation/kProfileMode-constant.html`.
@internal
const bool kProfileMode = bool.fromEnvironment('dart.vm.profile');

/// Copied from the flutter framework.
///
/// See: `https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html`.
@internal
const bool kDebugMode = !kReleaseMode && !kProfileMode;
