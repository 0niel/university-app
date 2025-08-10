// CLI tool to remove duplicate keys from a JSON ARB (or any JSON) file.
// Always writes the result back to the file (no success output).
// Usage:
//   dart tools/dedupe_arb.dart <path-to-json> [--sort]
// If --sort is provided, keys will be sorted alphabetically.

import 'dart:convert';
import 'dart:io';

void printUsage() {
  stdout.writeln('🧰 Usage: dart tools/dedupe_arb.dart <path-to-json> [--sort]');
}

Map<String, dynamic> flattenJsonPreserveLast(Map<String, dynamic> input) {
  final Map<String, dynamic> out = {};
  input.forEach((k, v) {
    out[k] = v;
  });
  return out;
}

String encodePretty(Map<String, dynamic> map) {
  const encoder = JsonEncoder.withIndent('  ');
  return '${encoder.convert(map)}\n';
}

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.first.startsWith('-')) {
    printUsage();
    exit(2);
  }

  final path = args.first;
  final sort = args.contains('--sort');

  final file = File(path);
  if (!await file.exists()) {
    stderr.writeln('❌ File not found: $path');
    exit(2);
  }

  late final Map<String, dynamic> jsonMap;
  try {
    final content = await file.readAsString();
    jsonMap = json.decode(content) as Map<String, dynamic>;
  } catch (e) {
    stderr.writeln('🚫 Failed to read/parse JSON: $e');
    exit(2);
  }

  var deduped = flattenJsonPreserveLast(jsonMap);

  if (sort) {
    final sortedKeys = deduped.keys.toList()..sort();
    final Map<String, dynamic> sorted = {for (final k in sortedKeys) k: deduped[k]};
    deduped = sorted;
  }

  final output = encodePretty(deduped);
  await file.writeAsString(output);
}
