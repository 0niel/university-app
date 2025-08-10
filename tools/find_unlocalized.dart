// A small CLI to scan Dart source for likely unlocalized user-facing strings.
// Usage:
//   dart tools/find_unlocalized.dart [--dir lib] [--verbose]
//
// It prints matches as: path:line: snippet
// Heuristics: looks for strings inside common UI widgets (Text, Tooltip.message,
// AppBar.title -> Text, SnackBar.content -> Text, TextSpan.text, IconButton.tooltip, Button.label -> Text, etc.).
// Skips lines containing ".l10n" or "AppLocalizations" references and generated/localization files.

import 'dart:convert';
import 'dart:io';

class MatchRecord {
  MatchRecord(this.file, this.lineNumber, this.line);

  final File file;
  final int lineNumber;
  final String line;

  @override
  String toString() => '${file.path}:$lineNumber: ${line.trim()}';
}

void printUsage() {
  stdout.writeln('🧰 Usage: dart tools/find_unlocalized.dart [--dir lib] [--verbose]');
}

final List<RegExp> defaultPatterns = [
  // Text('...') or Text("...")
  RegExp(r'Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"Text\s*\(\s*'(.{1,200}?)'"),
  // TextSpan(text: '...')
  RegExp(r'TextSpan\s*\([^)]*text\s*:\s*"(.{1,200}?)"'),
  RegExp(r"TextSpan\s*\([^)]*text\s*:\s*'(.{1,200}?)'"),
  // Tooltip(message: '...')
  RegExp(r'Tooltip\s*\([^)]*message\s*:\s*"(.{1,200}?)"'),
  RegExp(r"Tooltip\s*\([^)]*message\s*:\s*'(.{1,200}?)'"),
  // SnackBar(content: Text('...'))
  RegExp(r'SnackBar\s*\([^)]*content\s*:\s*Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"SnackBar\s*\([^)]*content\s*:\s*Text\s*\(\s*'(.{1,200}?)'"),
  // AppBar(title: Text('...'))
  RegExp(r'AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*'(.{1,200}?)'"),
  // IconButton(tooltip: '...') or IconButton.tooltip: '...'
  RegExp(r'IconButton[^)]*tooltip\s*:\s*"(.{1,200}?)"'),
  RegExp(r"IconButton[^)]*tooltip\s*:\s*'(.{1,200}?)'"),
  // Button widgets label/title text
  RegExp(r'(?:ElevatedButton|TextButton|FilledButton|OutlinedButton)[^)]*label\s*:\s*Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"(?:ElevatedButton|TextButton|FilledButton|OutlinedButton)[^)]*label\s*:\s*Text\s*\(\s*'(.{1,200}?)'"),
];

bool isLikelyLocalized(String line) {
  // Ignore if already using l10n or AppLocalizations
  if (line.contains('.l10n') ||
      line.contains('AppLocalizations') ||
      line.contains('tr(') ||
      line.contains('l10n:ignore')) {
    return true;
  }
  return false;
}

bool looksLikeHumanText(String text) {
  // Heuristic: contains letter (Latin or Cyrillic) and not only whitespace/symbols
  final hasLetters = RegExp(r"[A-Za-z\u0400-\u04FF]").hasMatch(text);
  return hasLetters;
}

Future<List<MatchRecord>> scanFile(File file, {bool verbose = false}) async {
  final List<MatchRecord> matches = [];
  final lines = const LineSplitter().convert(await file.readAsString());
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (isLikelyLocalized(line)) continue;
    for (final pattern in defaultPatterns) {
      final m = pattern.firstMatch(line);
      if (m != null) {
        final captured = m.groupCount >= 1 ? (m.group(1) ?? '') : '';
        if (captured.isNotEmpty && looksLikeHumanText(captured)) {
          matches.add(MatchRecord(file, i + 1, line));
          break;
        }
      }
    }
  }
  return matches;
}

Future<void> main(List<String> args) async {
  String dirPath = 'lib';
  bool verbose = false;

  for (int i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--help' || a == '-h') {
      printUsage();
      return;
    } else if (a == '--dir' && i + 1 < args.length) {
      dirPath = args[++i];
    } else if (a == '--verbose') {
      verbose = true;
    }
  }

  final root = Directory(dirPath);
  if (!await root.exists()) {
    stderr.writeln('Directory not found: $dirPath');
    exitCode = 2;
    return;
  }

  final List<MatchRecord> all = [];
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    // Normalize path separators for Windows
    final p = entity.path.replaceAll('\\', '/');

    if (p.contains('/l10n/') ||
        p.contains('/generated') ||
        p.contains('app_localizations') ||
        p.contains('/.dart_tool/') ||
        p.contains('/build/')) {
      continue;
    }
    try {
      final matches = await scanFile(entity, verbose: verbose);
      all.addAll(matches);
    } catch (e) {
      if (verbose) {
        stderr.writeln('Failed to scan ${entity.path}: $e');
      }
    }
  }

  if (all.isEmpty) {
    stdout.writeln('✅ No likely unlocalized strings found.');
    return;
  }

  for (final r in all) {
    stdout.writeln('⚠️  ${r.toString()}');
  }

  stdout.writeln('\n⚠️  Total potential issues: ${all.length}');
}
