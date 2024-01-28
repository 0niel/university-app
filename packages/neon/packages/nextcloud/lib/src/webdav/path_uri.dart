import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// A `Uri` like object that is specialized in file path handling.
@immutable
class PathUri {
  /// Creates a new path URI.
  const PathUri({
    required this.isAbsolute,
    required this.isDirectory,
    required this.pathSegments,
  });

  /// Creates a new `PathUri` object by parsing a [path] string.
  ///
  /// An empty [path] is considered to be the current working directory.
  factory PathUri.parse(String path) {
    final parts = path.split('/');
    if (parts.length == 1 && parts.single.isEmpty) {
      return PathUri(
        isAbsolute: false,
        isDirectory: true,
        pathSegments: BuiltList(),
      );
    }
    return PathUri(
      isAbsolute: parts.first.isEmpty,
      isDirectory: parts.last.isEmpty,
      pathSegments: BuiltList(parts.where((element) => element.isNotEmpty)),
    );
  }

  /// Creates a new empty path URI representing the current working directory.
  factory PathUri.cwd() => PathUri(
        isAbsolute: false,
        isDirectory: true,
        pathSegments: BuiltList(),
      );

  /// Whether the path is an absolute path.
  ///
  /// If `true` [path] will start with a slash.
  final bool isAbsolute;

  /// Whether the path is a directory.
  ///
  /// If `true` [path] will end with a slash.
  final bool isDirectory;

  /// Returns the path as a list of its segments.
  ///
  /// See [path] for getting the path as a string.
  final BuiltList<String> pathSegments;

  /// Returns the path as a string.
  ///
  /// See [pathSegments] for getting the path as a list of its segments.
  String get path {
    final buffer = StringBuffer();
    if (isAbsolute) {
      buffer.write('/');
    }
    buffer.writeAll(pathSegments, '/');
    if (isDirectory && pathSegments.isNotEmpty) {
      buffer.write('/');
    }
    return buffer.toString();
  }

  /// Returns the name of the last element in path.
  String get name => pathSegments.lastOrNull ?? '';

  /// Returns the parent of the path.
  PathUri? get parent {
    if (pathSegments.isNotEmpty) {
      return PathUri(
        isAbsolute: isAbsolute,
        isDirectory: true,
        pathSegments: pathSegments.rebuild((b) => b.removeLast()),
      );
    }

    return null;
  }

  /// Joins the current path with another [path].
  ///
  /// If the current path is not a directory a [StateError] will be thrown.
  /// See [isDirectory] for checking if the current path is a directory.
  PathUri join(PathUri other) {
    if (!isDirectory) {
      throw StateError('$this is not a directory.');
    }

    return PathUri(
      isAbsolute: isAbsolute,
      isDirectory: other.isDirectory,
      pathSegments: pathSegments.rebuild((b) => b.addAll(other.pathSegments)),
    );
  }

  /// Renames the last path segment and returns a new path URI.
  PathUri rename(String name) {
    if (name.contains('/')) {
      throw Exception('Path names must not contain /');
    }

    return PathUri(
      isAbsolute: isAbsolute,
      isDirectory: isDirectory,
      pathSegments: pathSegments.isNotEmpty
          ? pathSegments.rebuild(
              (b) => b
                ..removeLast()
                ..add(name),
            )
          : BuiltList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PathUri &&
      isAbsolute == other.isAbsolute &&
      isDirectory == other.isDirectory &&
      pathSegments == other.pathSegments;

  @override
  int get hashCode => Object.hashAll([
        isAbsolute,
        isDirectory,
        pathSegments,
      ]);

  @override
  String toString() => path;
}
