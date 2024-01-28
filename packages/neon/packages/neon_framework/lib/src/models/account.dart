import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/utils/findable.dart';
import 'package:nextcloud/nextcloud.dart';

part 'account.g.dart';

/// Credentials interface
@internal
@immutable
abstract interface class Credentials {
  /// Url of the server
  abstract final Uri serverURL;

  /// Username
  abstract final String username;

  /// App password
  abstract final String? password;
}

/// Account data.
@JsonSerializable()
@immutable
class Account implements Credentials, Findable {
  /// Creates a new account.
  Account({
    required this.serverURL,
    required this.username,
    this.password,
    this.userAgent,
  }) : client = NextcloudClient(
          serverURL,
          loginName: username,
          password: password,
          appPassword: password,
          userAgentOverride: userAgent,
          cookieJar: CookieJar(),
        );

  /// Creates a new account object from the given [json] data.
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  /// Parses this object into a json like map.
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  final Uri serverURL;
  @override
  final String username;
  @override
  final String? password;

  /// The user agent to use.
  final String? userAgent;

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.serverURL == serverURL &&
      other.username == username &&
      other.password == password &&
      other.userAgent == userAgent;

  @override
  int get hashCode => serverURL.hashCode + username.hashCode;

  /// An authenticated API client.
  final NextcloudClient client;

  /// The unique ID of the account.
  ///
  /// Implemented in a primitive way hashing the [username] and [serverURL].
  /// IDs are globally cached in [_idCache].
  @override
  String get id {
    final key = '$username@$serverURL';

    return _idCache[key] ??= sha1.convert(utf8.encode(key)).toString();
  }

  /// A human readable representation of [username] and [serverURL].
  String get humanReadableID {
    // Maybe also show path if it is not '/' ?
    final buffer = StringBuffer()
      ..write(username)
      ..write('@')
      ..write(serverURL.host);

    if (serverURL.hasPort) {
      buffer
        ..write(':')
        ..write(serverURL.port);
    }

    return buffer.toString();
  }

  /// Completes an incomplete [Uri] using the [serverURL].
  ///
  /// Some Nextcloud APIs return [Uri]s to resources on the server (e.g. an image) but only give an absolute path.
  /// Those [Uri]s need to be completed using the [serverURL] to have a working [Uri].
  ///
  /// The paths of the [serverURL] and the [uri] need to be join to get the full path, unless the [uri] path is already an absolute path.
  /// In that case an instance hosted at a sub folder will already contain the sub folder part in the [uri].
  Uri completeUri(Uri uri) {
    final result = serverURL.resolveUri(uri);
    if (!uri.hasAbsolutePath) {
      return result.replace(path: '${serverURL.path}/${uri.path}');
    }
    return result;
  }

  /// Get the necessary `Authorization` headers for a given [uri].
  ///
  /// This method ensures no credentials are sent to the wrong server.
  Map<String, String>? getAuthorizationHeaders(Uri uri) {
    if (uri.toString().startsWith(serverURL.toString())) {
      return client.authentications?.firstOrNull?.headers;
    }

    return null;
  }

  /// Removes the [serverURL] part from the [uri].
  ///
  /// Should be used when trying to push a [uri] from an API to the router as it might contain the scheme, host and sub path of the instance which will not work with the router.
  Uri stripUri(Uri uri) => Uri.parse(uri.toString().replaceFirst(serverURL.toString(), ''));
}

/// Global [Account.id] cache.
Map<String, String> _idCache = {};

/// QRcode Login credentials.
///
/// The Credentials as provided by the server when manually creating an app
/// password.
@internal
@immutable
class LoginQRcode implements Credentials {
  /// Creates a new LoginQRcode object.
  @visibleForTesting
  const LoginQRcode({
    required this.serverURL,
    required this.username,
    required this.password,
  });

  @override
  final Uri serverURL;
  @override
  final String username;
  @override
  final String password;

  /// Pattern matching the full QRcode content.
  static final _loginQRcodeUrlRegex = RegExp(r'^nc://login/user:(.*)&password:(.*)&server:(.*)$');

  /// Pattern matching the path part of the QRcode.
  ///
  /// This is used when launching the app through an intent.
  static final _loginQRcodePathRegex = RegExp(r'^/user:(.*)&password:(.*)&server:(.*)$');

  /// Creates a new `LoginQRcode` object by parsing a url string.
  ///
  /// If the [url] string is not valid as a LoginQRcode a [FormatException] is
  /// thrown.
  ///
  /// Example:
  /// ```dart
  /// final loginQRcode =
  ///     LoginQRcode.parse('nc://login/user:JohnDoe&password:super_secret&server:example.com');
  /// print(loginQRcode.serverURL); // JohnDoe
  /// print(loginQRcode.username); // super_secret
  /// print(loginQRcode.password); // example.com
  ///
  /// LoginQRcode.parse('::Not valid LoginQRcode::'); // Throws FormatException.
  /// ```
  static LoginQRcode parse(String url) {
    for (final regex in [_loginQRcodeUrlRegex, _loginQRcodePathRegex]) {
      final matches = regex.allMatches(url);
      if (matches.isEmpty) {
        continue;
      }

      final match = matches.single;
      if (match.groupCount != 3) {
        continue;
      }

      return LoginQRcode(
        serverURL: Uri.parse(match.group(3)!),
        username: match.group(1)!,
        password: match.group(2)!,
      );
    }

    throw const FormatException();
  }

  /// Creates a new `LoginQRcode` object by parsing a url string.
  ///
  /// Returns `null` if the [url] string is not valid as a LoginQRcode.
  ///
  /// Example:
  /// ```dart
  /// final loginQRcode =
  ///     LoginQRcode.parse('nc://login/user:JohnDoe&password:super_secret&server:example.com');
  /// print(loginQRcode.serverURL); // JohnDoe
  /// print(loginQRcode.username); // super_secret
  /// print(loginQRcode.password); // example.com
  ///
  /// final notLoginQRcode = LoginQRcode.tryParse('::Not valid LoginQRcode::');
  /// print(notLoginQRcode); // null
  /// ```
  static LoginQRcode? tryParse(String url) {
    try {
      return parse(url);
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is LoginQRcode && other.serverURL == serverURL && other.username == username && other.password == password;

  @override
  int get hashCode => Object.hashAll([
        serverURL,
        username,
        password,
      ]);
}
