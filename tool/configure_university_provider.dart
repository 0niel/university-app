import 'dart:io';

import 'src/university_provider_configurator.dart';
import 'src/university_provider_source.dart';

export 'src/university_provider_configurator.dart' show RepositoryAccess;

void main(List<String> arguments) {
  try {
    configureProvider(Directory.current, arguments);
  } on Object catch (error) {
    stderr.writeln(error);
    exitCode = 64;
  }
}

void configureProvider(
  Directory root,
  List<String> arguments, {
  RepositoryAccess canReach = gitRepositoryReachable,
}) => UniversityProviderConfigurator(root: root, canReach: canReach).configure(
  UniversityProviderSource.parse(arguments),
);
