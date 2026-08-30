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
    var normalized = value.endsWith('/') && value.length > 1
        ? value.substring(0, value.length - 1)
        : value;
    if (normalized == '/info') normalized = '/feed';
    final allowed = allowedRoots.any(
      (root) => normalized == root || normalized.startsWith('$root/'),
    );
    return allowed ? normalized : null;
  }

  static Uri shareLink(
    String location, {
    UniversityConfig? config,
  }) {
    final deployment = config ?? .current;
    final normalized = normalizeLocation(location) ?? '/feed';
    return Uri.https(
      deployment.webAppHost,
      '${deployment.webAppPathPrefix}$normalized',
    );
  }
}
