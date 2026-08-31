import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

void printUsage() {
  stdout.writeln(
    '🧰 Usage: dart tools/dedupe_arb.dart <path-to-json> [--sort]',
  );
}

Map<String, dynamic> flattenJsonPreserveLast(Map<String, dynamic> input) {
  final out = <String, dynamic>{};
  input.forEach((k, v) {
    out[k] = v;
  });
  return out;
}

String encodePretty(Map<String, dynamic> map) {
  const encoder = JsonEncoder.withIndent('  ');
  return '${encoder.convert(map)}\n';
}

void main(List<String> args) {
  final path = args.firstOrNull;
  if (path == null || path.startsWith('-')) {
    printUsage();
    exit(2);
  }

  final sort = args.contains('--sort');

  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('❌ File not found: $path');
    exit(2);
  }

  final Map<String, dynamic> jsonMap;
  try {
    final content = file.readAsStringSync();
    jsonMap = json.decode(content) as Map<String, dynamic>;
  } on Exception catch (e) {
    stderr.writeln('🚫 Failed to read/parse JSON: $e');
    exit(2);
  }

  var deduped = flattenJsonPreserveLast(jsonMap);

  if (sort) {
    final sortedKeys = deduped.keys.toList()..sort();
    deduped = <String, dynamic>{
      for (final k in sortedKeys) k: deduped[k],
    };
  }

  final output = encodePretty(deduped);
  file.writeAsStringSync(output);
}
