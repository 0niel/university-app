import 'package:build/build.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

// Also update the README.md if you change this.
final dependencies = {
  'built_collection': Version.parse('5.0.0'),
  'built_value': Version.parse('8.9.0'),
  'collection': Version.parse('1.0.0'),
  'dynamite_runtime': Version.parse('0.1.0'),
  'http': Version.parse('1.2.0'),
  'meta': Version.parse('1.0.0'),
  'uri': Version.parse('1.0.0'),
};

// Also update the README.md if you change this.
final devDependencies = {
  'built_value_generator': Version.parse('8.9.0'),
};

/// Checks whether the correct version of the dependencies are present in the pubspec.yaml file.
Future<({bool hasFatal, String messages})> helperVersionCheck(BuildStep buildStep) async {
  final pubspecAsset = AssetId(buildStep.inputId.package, 'pubspec.yaml');

  if (!await buildStep.canRead(pubspecAsset)) {
    return (
      hasFatal: false,
      messages: 'Failed to read the pubspec.yaml file. Version constraints of required packages can not be validated.',
    );
  }

  final pubspecContent = await buildStep.readAsString(pubspecAsset);
  final pubspec = Pubspec.parse(pubspecContent, sourceUrl: pubspecAsset.uri);

  final messages = StringBuffer();
  var hasFatal = false;

  for (final constraint in dependencies.entries) {
    final result = _validateVersion(pubspec.dependencies, constraint.key, constraint.value);

    if (result.message != null) {
      messages.writeln(result.message);
    }

    if (result.isFatal) {
      hasFatal = true;
    }
  }

  for (final constraint in devDependencies.entries) {
    final result = _validateVersion(pubspec.devDependencies, constraint.key, constraint.value);

    if (result.message != null) {
      messages.writeln(result.message);
    }

    if (result.isFatal) {
      hasFatal = true;
    }
  }

  return (hasFatal: hasFatal, messages: messages.toString());
}

({bool isFatal, String? message}) _validateVersion(
  Map<String, Dependency> dependencies,
  String packageName,
  Version minVersion,
) {
  final dependency = dependencies[packageName];
  final maxVersion = minVersion.nextBreaking;

  if (dependency == null) {
    return (
      isFatal: false,
      message:
          'Could not find the dependency on `$packageName` in pubspec.yaml file. Compatibility check is being skipped.',
    );
  } else if (dependency is HostedDependency) {
    final constraint = dependency.version;
    final invalidConstraintMessage =
        'The version constraint $constraint on `$packageName` allows versions before $minVersion or after $maxVersion which is not allowed.';

    if (constraint is Version && (constraint < minVersion || constraint > maxVersion)) {
      return (isFatal: true, message: invalidConstraintMessage);
    }

    final range = constraint as VersionRange;
    final rangeMin = range.min;
    final rangeMax = range.max;

    if (rangeMin == null || rangeMax == null || rangeMin < minVersion || rangeMax > maxVersion) {
      return (isFatal: true, message: invalidConstraintMessage);
    }
  }

  return (isFatal: false, message: null);
}
