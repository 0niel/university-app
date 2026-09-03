import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

String packageTestRuntime(String packageName, Map<String, Object?> graph) {
  final entries = graph['packages'];
  if (entries is! List<Object?>) {
    throw const FormatException('Resolved package graph is missing packages');
  }
  final packages = <String, Map<String, Object?>>{};
  for (final entry in entries) {
    if (entry is! Map<String, Object?> || entry['name'] is! String) {
      throw const FormatException(
        'Resolved package graph contains an invalid package',
      );
    }
    final name = entry['name']! as String;
    if (packages.containsKey(name)) {
      throw FormatException('Resolved package graph contains duplicate $name');
    }
    packages[name] = entry;
  }
  final pending = <String>[packageName];
  final visited = <String>{};
  while (pending.isNotEmpty) {
    final name = pending.removeLast();
    if (!visited.add(name)) continue;
    if (name == 'flutter') return 'flutter';
    final package = packages[name];
    if (package == null) {
      throw FormatException('Resolved package graph is missing $name');
    }
    for (final key in [
      'dependencies',
      if (name == packageName) 'devDependencies',
    ]) {
      final dependencies = package[key] ?? const <String>[];
      if (dependencies is! List<Object?> ||
          dependencies.any((dependency) => dependency is! String)) {
        throw FormatException('Invalid $key for $name');
      }
      pending.addAll(dependencies.cast<String>());
    }
  }
  return 'dart';
}

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart tool/package_test_runtime.dart <package-directory>',
    );
    exitCode = 64;
    return;
  }
  final directory = Directory(arguments.single).absolute;
  final pubspec = loadYaml(
    File('${directory.path}/pubspec.yaml').readAsStringSync(),
  );
  if (pubspec is! YamlMap || pubspec['name'] is! String) {
    throw const FormatException('Package pubspec is missing its name');
  }
  var workspace = directory;
  while (true) {
    final graphFile = File('${workspace.path}/.dart_tool/package_graph.json');
    if (graphFile.existsSync()) {
      final graph = jsonDecode(graphFile.readAsStringSync());
      if (graph is! Map<String, Object?>) {
        throw const FormatException('Resolved package graph is not an object');
      }
      stdout.writeln(packageTestRuntime(pubspec['name'] as String, graph));
      return;
    }
    final parent = workspace.parent;
    if (parent.path == workspace.path) {
      throw const FileSystemException('Resolved package graph is unavailable');
    }
    workspace = parent;
  }
}
