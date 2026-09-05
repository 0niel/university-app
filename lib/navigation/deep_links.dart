import 'package:rtu_mirea_app/config/config.dart';

abstract final class DeepLinks {
  static const allowedRoots = [
    '/feed',
    '/schedule',
    '/map',
    '/services',
    '/profile',
    '/search',
  ];

  static String? normalize(
    Uri uri, {
    UniversityConfig? config,
  }) {
    final deployment = config ?? .current;
    String? location;
    if (uri.scheme == deployment.deepLinkScheme) {
      location = '/${uri.host}${uri.path}';
    } else if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == deployment.webAppHost &&
        uri.path.startsWith('${deployment.webAppPathPrefix}/')) {
      location = uri.path.substring(deployment.webAppPathPrefix.length);
    }
    if (location == null) return null;
    if (uri.query.isNotEmpty) location = '$location?${uri.query}';
    return normalizeLocation(location);
  }

  static String? normalizeLocation(String? location) {
    final value = location?.trim();
    if (value == null || value.isEmpty || !value.startsWith('/')) {
      return null;
    }
    final parsed = Uri.tryParse(value);
    if (parsed == null || parsed.hasScheme || parsed.hasAuthority) return null;
    final uri = parsed.normalizePath();
    var path = uri.path;
    if (path.endsWith('/') && path.length > 1) {
      path = path.substring(0, path.length - 1);
    }
    if (path == '/' || path == '/info') path = '/feed';
    final allowed = allowedRoots.any(
      (root) => path == root || path.startsWith('$root/'),
    );
    return allowed ? uri.replace(path: path).toString() : null;
  }

  static Uri shareLink(
    String location, {
    UniversityConfig? config,
  }) {
    final deployment = config ?? .current;
    final normalized = normalizeLocation(location) ?? '/feed';
    final parsed = Uri.parse(normalized);
    return Uri.https(
      deployment.webAppHost,
      '${deployment.webAppPathPrefix}${parsed.path}',
    ).replace(query: parsed.hasQuery ? parsed.query : null);
  }

  static Uri appLink(
    String location, {
    UniversityConfig? config,
  }) {
    final deployment = config ?? .current;
    final normalized = normalizeLocation(location) ?? '/feed';
    final parsed = Uri.parse(normalized);
    final segments = parsed.pathSegments;
    return Uri(
      scheme: deployment.deepLinkScheme,
      host: segments.isEmpty ? 'feed' : segments.first,
      pathSegments: segments.skip(1),
      query: parsed.hasQuery ? parsed.query : null,
    );
  }
}
