sealed class UniversityProviderSource {
  const UniversityProviderSource();

  factory UniversityProviderSource.parse(List<String> arguments) {
    final values = <String, String>{};
    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments[index];
      if (values.containsKey(argument)) {
        throw ArgumentError('Duplicate option.');
      }
      if (argument == '--remove' || argument == '--pinned') {
        values[argument] = 'true';
      } else if (const {
            '--local',
            '--repository',
            '--ref',
            '--path',
          }.contains(argument) &&
          index + 1 < arguments.length) {
        values[argument] = arguments[++index];
      } else {
        throw ArgumentError(
          'Use --local <directory>, --repository <https-url> --ref <commit> '
          '[--path <package>], --pinned, or --remove.',
        );
      }
    }
    final choices = const [
      '--local',
      '--repository',
      '--remove',
      '--pinned',
    ].where(values.containsKey).length;
    if (choices != 1) {
      throw ArgumentError('Choose exactly one provider source.');
    }
    if (!values.containsKey('--repository') &&
        (values.containsKey('--ref') || values.containsKey('--path'))) {
      throw ArgumentError('--ref and --path require --repository.');
    }
    if (values['--local'] case final String path) {
      return LocalUniversityProvider._(path);
    }
    if (values['--repository'] case final String url) {
      return UniversityProviderSource.git(
        repository: url,
        ref: values['--ref'],
        path: values['--path'],
      );
    }
    if (values.containsKey('--pinned')) {
      return const PinnedUniversityProvider();
    }
    return const DefaultUniversityProvider();
  }

  factory UniversityProviderSource.git({
    required String repository,
    required String? ref,
    String? path,
  }) {
    final uri = Uri.tryParse(repository);
    final package = path ?? '.';
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError('Repository must be a credential-free HTTPS URL.');
    }
    if (ref == null || !RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(ref)) {
      throw ArgumentError(
        'Pin the provider to a full 40-character commit SHA.',
      );
    }
    if (package.isEmpty ||
        package.startsWith('/') ||
        package.contains(r'\') ||
        package.split('/').contains('..') ||
        package.contains(':')) {
      throw ArgumentError('Package path must remain inside the repository.');
    }
    return GitUniversityProvider._(repository: uri, ref: ref, path: package);
  }
}

final class DefaultUniversityProvider extends UniversityProviderSource {
  const DefaultUniversityProvider();
}

final class PinnedUniversityProvider extends UniversityProviderSource {
  const PinnedUniversityProvider();
}

final class LocalUniversityProvider extends UniversityProviderSource {
  const LocalUniversityProvider._(this.path);
  final String path;
}

final class GitUniversityProvider extends UniversityProviderSource {
  const GitUniversityProvider._({
    required this.repository,
    required this.ref,
    required this.path,
  });
  final Uri repository;
  final String ref;
  final String path;
}
