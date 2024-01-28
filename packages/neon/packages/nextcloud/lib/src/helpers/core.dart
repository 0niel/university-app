// ignore_for_file: public_member_api_docs

import 'package:nextcloud/src/api/core.openapi.dart' as core;
import 'package:nextcloud/src/helpers/common.dart';
import 'package:version/version.dart';

/// Minimum version of core/Server supported
final minVersion = Version(26, 0, 0);

/// Maximum major of core/Server supported
const maxMajor = 28;

extension CoreVersionCheck on core.$Client {
  /// Check if the core/Server version is supported by this client
  ///
  /// Also returns the minimum supported version
  VersionCheck getVersionCheck(core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data capabilities) {
    final version = Version(
      capabilities.version.major,
      capabilities.version.minor,
      capabilities.version.micro,
    );
    return VersionCheck(
      versions: [version],
      minimumVersion: minVersion,
      maximumMajor: maxMajor,
    );
  }
}

extension CoreStatusVersionCheck on core.Status {
  /// Check if the core/Server version is supported
  VersionCheck get versionCheck => VersionCheck(
        versions: [Version.parse(version)],
        minimumVersion: minVersion,
        maximumMajor: maxMajor,
      );
}

enum ShareType {
  user,
  group,
  usergroup,
  link,
  email,
  @Deprecated('No longer used')
  contact,
  remote,
  circle,
  guest,
  remoteGroup,
  room,
  @Deprecated('Only used internally')
  userroom,
  deck,
  deckUser,
}
