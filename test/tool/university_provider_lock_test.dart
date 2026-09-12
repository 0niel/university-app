import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('committed lock resolves the default university provider', () {
    final overrides = File('pubspec_overrides.yaml');
    if (overrides.existsSync()) {
      final document = loadYaml(overrides.readAsStringSync());
      final selected =
          document is YamlMap &&
          document['dependency_overrides'] is YamlMap &&
          (document['dependency_overrides'] as YamlMap).containsKey(
            'university_provider',
          );
      if (selected) {
        markTestSkipped('An institution provider override is active.');
        return;
      }
    }
    final lock = loadYaml(File('pubspec.lock').readAsStringSync()) as YamlMap;
    final provider = (lock['packages'] as YamlMap)['university_provider'];
    expect(provider, isA<YamlMap>());
    final description = (provider as YamlMap)['description'] as YamlMap;
    expect(provider['source'], 'path');
    expect(description['path'], 'packages/university_provider');
    expect(description['relative'], isTrue);
  });

  test('provider pin references an immutable revision', () {
    final pin = File('config/university_provider.json').readAsStringSync();
    expect(pin, matches(RegExp(r'"ref":\s*"[0-9a-f]{40}"')));
    expect(
      pin,
      matches(RegExp(r'"repository":\s*"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+"')),
    );
  });
}
