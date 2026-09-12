import 'dart:convert';
import 'dart:io';

import 'university_provider_source.dart';

final class UniversityProviderPin {
  const UniversityProviderPin._({
    required this.repository,
    required this.ref,
    required this.path,
  });

  factory UniversityProviderPin.read(File file) {
    if (!file.existsSync()) {
      throw ArgumentError('Provider pin ${file.path} is missing.');
    }
    final document = jsonDecode(file.readAsStringSync());
    if (document is! Map<String, Object?> ||
        document.keys.any(
          (key) => !const {'repository', 'ref', 'path'}.contains(key),
        )) {
      throw const FormatException(
        'Provider pin must contain repository, ref and path.',
      );
    }
    final repository = document['repository'];
    final ref = document['ref'];
    final path = document['path'] ?? '.';
    if (repository is! String ||
        !RegExp(r'^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$').hasMatch(repository) ||
        repository.endsWith('.git')) {
      throw const FormatException(
        'Provider pin repository must be a GitHub owner/name.',
      );
    }
    if (ref is! String || path is! String) {
      throw const FormatException('Provider pin ref and path must be strings.');
    }
    final source =
        UniversityProviderSource.git(
              repository: 'https://github.com/$repository.git',
              ref: ref,
              path: path,
            )
            as GitUniversityProvider;
    return UniversityProviderPin._(
      repository: repository,
      ref: source.ref,
      path: source.path,
    );
  }

  static const fileName = 'config/university_provider.json';

  final String repository;
  final String ref;
  final String path;

  Uri get url => Uri.https('github.com', '/$repository.git');

  GitUniversityProvider get source =>
      UniversityProviderSource.git(
            repository: url.toString(),
            ref: ref,
            path: path,
          )
          as GitUniversityProvider;
}
