import 'dart:io';

const forbiddenPaths = <String>{
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/DigitalPassHostApduService.kt',
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/DigitalPassStore.kt',
  'android/app/src/main/kotlin/ninja/mirea/mireaapp/Utils.kt',
  'android/app/src/main/res/xml/apduservice.xml',
};

const forbiddenAndroidTerms = <String>{
  'DigitalPassHostApduService',
  'DigitalPassStore',
  'HostApduService',
  'BIND_NFC_SERVICE',
  'host_apdu_service',
};

const auditedAndroidExtensions = <String>{
  '.gradle',
  '.java',
  '.kt',
  '.kts',
  '.properties',
  '.xml',
};

void main(List<String> arguments) {
  final tracked = _git(<String>[
    'ls-files',
  ]).split('\n').where((line) => line.isNotEmpty).toSet();
  final violations = <String>{
    ...tracked
        .intersection(forbiddenPaths)
        .where((path) => File(path).existsSync()),
    ...tracked.where((path) => path.startsWith('android/private/')),
  };

  for (final path in tracked.where(
    (path) =>
        path.startsWith('android/') &&
        auditedAndroidExtensions.any(path.endsWith),
  )) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final contents = file.readAsStringSync();
    if (forbiddenAndroidTerms.any(contents.contains)) violations.add(path);
  }

  final ignored = Process.runSync(
    'git',
    <String>['check-ignore', '-q', 'android/private/nfc-pass-android'],
    runInShell: true,
  );
  if (ignored.exitCode != 0) violations.add('.gitignore');

  if (arguments.contains('--history')) {
    final history = _git(<String>[
      'log',
      '--format=',
      '--name-only',
      'HEAD',
      '--',
      ...forbiddenPaths,
      'android/private',
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
