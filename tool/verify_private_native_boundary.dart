import 'dart:io';

const kForbiddenPaths = {
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/DigitalPassHostApduService.kt',
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/DigitalPassStore.kt',
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/Utils.kt',
  'android/app/src/main/res/xml/apduservice.xml',
};

const kForbiddenAndroidTerms = {
  'DigitalPassHostApduService',
  'DigitalPassStore',
  'HostApduService',
  'BIND_NFC_SERVICE',
  'host_apdu_service',
};

const kAuditedAndroidExtensions = {
  '.gradle',
  '.java',
  '.kt',
  '.kts',
  '.properties',
  '.xml',
};

void main(List<String> arguments) {
  final tracked = _git([
    'ls-files',
  ]).split('\n').where((line) => line.isNotEmpty).toSet();
  final violations = <String>{
    ...tracked
        .intersection(kForbiddenPaths)
        .where((path) => File(path).existsSync()),
    ...tracked.where((path) => path.startsWith('android/private/')),
    ...tracked.where((path) => path.startsWith('private/')),
  };

  for (final path in tracked.where(
    (candidate) =>
        candidate.startsWith('android/') &&
        kAuditedAndroidExtensions.any(candidate.endsWith),
  )) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final contents = file.readAsStringSync();
    if (kForbiddenAndroidTerms.any(contents.contains)) violations.add(path);
  }

  for (final private in const <String>[
    'android/private/nfc-pass-android',
    'private/university_provider',
  ]) {
    final ignored = Process.runSync(
      'git',
      ['check-ignore', '-q', private],
      runInShell: true,
    );
    if (ignored.exitCode != 0) violations.add('.gitignore');
  }

  if (arguments.contains('--history')) {
    final history = _git([
      'log',
      '--format=',
      '--name-only',
      'HEAD',
      '--',
      ...kForbiddenPaths,
      'android/private',
      'private',
    ]).trim();
    if (history.isNotEmpty) violations.add('git history');
  }

  if (violations.isNotEmpty) {
    stderr.writeln('Private native boundary violation:');
    for (final violation in violations.toList()..sort()) {
      stderr.writeln('  $violation');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Public native boundary is clean.');
}

String _git(List<String> arguments) {
  final result = Process.runSync('git', arguments, runInShell: true);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }
  return result.stdout as String;
}
