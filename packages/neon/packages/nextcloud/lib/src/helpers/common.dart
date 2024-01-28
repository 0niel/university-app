import 'package:meta/meta.dart';
import 'package:version/version.dart';

/// Holds the [versions], [minimumVersion] and [maximumMajor] of an app.
@immutable
class VersionCheck {
  /// Creates a new [VersionCheck].
  ///
  /// If the [maximumMajor] is `null` the compatibility of the major of the [minimumVersion] is checked.
  VersionCheck({
    required this.versions,
    required this.minimumVersion,
    required int? maximumMajor,
  }) : maximumMajor = maximumMajor ?? minimumVersion.major;

  /// Current version of the app.
  final List<Version>? versions;

  /// Minimum version of the app.
  final Version minimumVersion;

  /// Maximum major version of the app.
  late final int maximumMajor;

  /// Whether the [versions] is allowed by the [minimumVersion] and [maximumMajor].
  ///
  /// If [versions] is `null` or empty it is assumed that the app is supported.
  /// Only one of the [versions] has to be supported to return `true`.
  bool get isSupported {
    if (versions == null || versions!.isEmpty) {
      return true;
    }

    for (final version in versions!) {
      if (version >= minimumVersion && version.major <= maximumMajor) {
        return true;
      }
    }

    return false;
  }
}
