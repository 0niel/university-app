/// Helpers extension for [Uri]s.
///
/// This might evolve into a separate class implementing the [Uri] interface in the future.
///
extension UriExtension on Uri {
  /// Similar to [normalizePath] but it will also remove empty [pathSegments].
  Uri normalizeEmptyPath() {
    final normalized = normalizePath();
    if (normalized.path.endsWith('/')) {
      return normalized.replace(pathSegments: normalized.pathSegments.where((s) => s.isNotEmpty));
    }

    return normalized;
  }
}
