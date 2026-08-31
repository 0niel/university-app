import 'dart:convert';
import 'dart:io';

class FindUnlocalized {
  const FindUnlocalized(this.file, this.lineNumber, this.line);

  final File file;
  final int lineNumber;
  final String line;

  @override
  String toString() => '${file.path}:$lineNumber: ${line.trim()}';
}

void printUsage() {
  stdout.writeln(
    '🧰 Usage: dart tools/find_unlocalized.dart [--dir lib] [--verbose]',
  );
}

final List<RegExp> defaultPatterns = [
  RegExp(r'Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"Text\s*\(\s*'(.{1,200}?)'"),
  RegExp(r'TextSpan\s*\([^)]*text\s*:\s*"(.{1,200}?)"'),
  RegExp(r"TextSpan\s*\([^)]*text\s*:\s*'(.{1,200}?)'"),
  RegExp(r'Tooltip\s*\([^)]*message\s*:\s*"(.{1,200}?)"'),
  RegExp(r"Tooltip\s*\([^)]*message\s*:\s*'(.{1,200}?)'"),
  RegExp(r'SnackBar\s*\([^)]*content\s*:\s*Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"SnackBar\s*\([^)]*content\s*:\s*Text\s*\(\s*'(.{1,200}?)'"),
  RegExp(r'AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*"(.{1,200}?)"'),
  RegExp(r"AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*'(.{1,200}?)'"),
  RegExp(r'IconButton[^)]*tooltip\s*:\s*"(.{1,200}?)"'),
  RegExp(r"IconButton[^)]*tooltip\s*:\s*'(.{1,200}?)'"),
  RegExp(
    r'(?:ElevatedButton|TextButton|FilledButton|OutlinedButton)[^)]*label\s*:\s*Text\s*\(\s*"(.{1,200}?)"',
  ),
  RegExp(
    r"(?:ElevatedButton|TextButton|FilledButton|OutlinedButton)[^)]*label\s*:\s*Text\s*\(\s*'(.{1,200}?)'",
  ),
];

bool isLikelyLocalized(String line) {
  if (line.contains('.l10n') ||
      line.contains('AppLocalizations') ||
      line.contains('tr(') ||
      line.contains('l10n:ignore')) {
    return true;
  }
  return false;
}

bool looksLikeHumanText(String text) {
  final hasLetters = RegExp(r'[A-Za-z\u0400-\u04FF]').hasMatch(text);
  return hasLetters;
}

List<FindUnlocalized> scanFile(File file) {
  final matches = <FindUnlocalized>[];
  final lines = const LineSplitter().convert(file.readAsStringSync());
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (isLikelyLocalized(line)) continue;
    for (final pattern in defaultPatterns) {
      final m = pattern.firstMatch(line);
      if (m != null) {
        final captured = m.groupCount >= 1 ? (m.group(1) ?? '') : '';
        if (captured.isNotEmpty && looksLikeHumanText(captured)) {
          matches.add(FindUnlocalized(file, i + 1, line));
          break;
        }
      }
    }
  }
  return matches;
}

void main(List<String> args) {
  var dirPath = 'lib';
  var verbose = false;

  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--help' || a == '-h') {
      printUsage();
      return;
    } else if (a == '--dir' && i + 1 < args.length) {
      i += 1;
      dirPath = args[i];
    } else if (a == '--verbose') {
      verbose = true;
    }
  }

  final root = Directory(dirPath);
  if (!root.existsSync()) {
    stderr.writeln('Directory not found: $dirPath');
    exitCode = 2;
    return;
  }

  final all = <FindUnlocalized>[];
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final p = entity.path.replaceAll(r'\', '/');

    if (p.contains('/l10n/') ||
        p.contains('/generated') ||
        p.contains('app_localizations') ||
        p.contains('/.dart_tool/') ||
        p.contains('/build/')) {
      continue;
    }
    try {
      final matches = scanFile(entity);
      all.addAll(matches);
    } on FileSystemException catch (e) {
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
    stdout.writeln('⚠️  $r');
  }

  stdout.writeln('\n⚠️  Total potential issues: ${all.length}');
}
