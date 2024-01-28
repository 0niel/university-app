import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

String? _userAgent;

/// Sets the user agent.
///
/// It can be accessed with [neonUserAgent].
@internal
void buildUserAgent(PackageInfo packageInfo) {
  var buildNumber = packageInfo.buildNumber;
  if (buildNumber.isEmpty) {
    buildNumber = '1';
  }
  _userAgent = 'Neon ${packageInfo.version}+$buildNumber';
}

/// Gets the current user agent.
///
/// It must be set by calling [buildUserAgent] before. If not set a [StateError] will be thrown.
@internal
String get neonUserAgent {
  if (_userAgent == null) {
    throw StateError('The user agent has not been set up. Please use `buildUserAgent` before.');
  }
  return _userAgent!;
}
