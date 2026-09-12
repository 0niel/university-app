import 'dart:io';

import 'src/university_provider_configurator.dart';
import 'src/university_provider_source.dart';

void main(List<String> arguments) {
  try {
    configureProvider(Directory.current, arguments);
  } on Object catch (error) {
    stderr.writeln(error);
    exitCode = 64;
  }
}

void configureProvider(Directory root, List<String> arguments) =>
    UniversityProviderConfigurator(root: root).configure(
      UniversityProviderSource.parse(arguments),
    );
