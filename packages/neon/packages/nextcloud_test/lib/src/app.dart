import 'package:meta/meta.dart';
import 'package:version/version.dart';

/// Describes a release of an [App] from https://apps.nextcloud.com
@internal
typedef AppRelease = ({
  Version version,
  String url,
  Version minimumServerVersion,
  Version maximumServerVersion,
});

/// Describes an app from https://apps.nextcloud.com
@internal
typedef App = ({
  String id,
  List<AppRelease> releases,
});

@internal
extension AppFindLatestRelease on App {
  AppRelease? findLatestCompatibleRelease(Version serverVersion, {bool allowUnstable = false}) {
    final compatibleReleases = releases
        .where(
          (release) =>
              serverVersion >= release.minimumServerVersion &&
              serverVersion < release.maximumServerVersion.incrementMajor() &&
              (allowUnstable || !release.version.isPreRelease),
        )
        .toList()
      ..sort((a, b) => b.version.compareTo(a.version));
    return compatibleReleases.firstOrNull;
  }

  AppRelease findLatestRelease() {
    final sortedReleases = releases..sort((a, b) => b.version.compareTo(a.version));
    return sortedReleases.first;
  }
}

@internal
extension AppReleaseFindLatestServerVersion on AppRelease {
  Version findLatestServerVersion(List<Version> serverVersions) {
    final compatibleReleases = serverVersions
        .where(
          (serverVersion) =>
              serverVersion >= minimumServerVersion && serverVersion < maximumServerVersion.incrementMajor(),
        )
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return compatibleReleases.first;
  }
}
