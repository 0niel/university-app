import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('keeps voice input optional without filtering Android devices', () {
    final manifest = XmlDocument.parse(
      File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
    ).rootElement;
    const android = 'http://schemas.android.com/apk/res/android';
    final microphones = manifest
        .findElements('uses-feature')
        .where(
          (element) =>
              element.getAttribute('name', namespace: android) ==
              'android.hardware.microphone',
        );

    expect(microphones, hasLength(1));
    expect(
      microphones.single.getAttribute('required', namespace: android),
      'false',
    );
    expect(
      manifest
          .findElements('uses-permission')
          .any(
            (element) =>
                element.getAttribute('name', namespace: android) ==
                'android.permission.RECORD_AUDIO',
          ),
      isTrue,
    );
    expect(
      manifest
          .findElements('queries')
          .expand((queries) => queries.findAllElements('action'))
          .any(
            (element) =>
                element.getAttribute('name', namespace: android) ==
                'android.speech.RecognitionService',
          ),
      isTrue,
    );
  });

  test('hardens Android production releases', () {
    final gradle = File('android/app/build.gradle').readAsStringSync();
    final workflow = File(
      '.github/workflows/beta-release.yml',
    ).readAsStringSync();

    expect(gradle, contains('minifyEnabled true'));
    expect(gradle, contains('shrinkResources true'));
    expect(gradle, contains('proguard-android-optimize.txt'));
    expect(gradle, contains("debugSymbolLevel 'FULL'"));
    expect(workflow, contains('--obfuscate'));
    expect(workflow, contains('--split-debug-info='));
    expect(workflow, contains('openssl smime -encrypt'));
    expect(workflow, contains('release_symbols_public.pem'));
    expect(workflow, contains('symbols.cms'));
    expect(
      workflow,
      isNot(contains(r'dist/university-app-$RELEASE_VERSION-mapping.txt')),
    );
    expect(
      workflow,
      isNot(
        contains(
          r'dist/university-app-$RELEASE_VERSION-native-symbols.zip',
        ),
      ),
    );
  });

  test('hardens iOS releases and patches', () {
    final workflow = File(
      '.github/workflows/shorebird-release.yml',
    ).readAsStringSync();
    final codemagic = File('codemagic.yaml').readAsStringSync();
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    final gitignore = File('.gitignore').readAsStringSync();
    final decryptScript = File(
      'tool/decrypt_release_symbols.ps1',
    ).readAsStringSync();

    expect(workflow, contains('shorebird release ios'));
    expect(workflow, contains('--obfuscate'));
    expect(workflow, contains('--split-debug-info='));
    expect(workflow, isNot(contains('shorebirdtech/shorebird-release@')));
    expect(RegExp('--obfuscate').allMatches(codemagic), hasLength(1));
    expect(RegExp('--split-debug-info=').allMatches(codemagic), hasLength(2));
    expect(codemagic, isNot(contains('build/**/*.symbols')));
    expect(codemagic, isNot(contains('dSYMs/*.dSYM')));
    expect(
      RegExp('openssl smime -encrypt').allMatches(codemagic),
      hasLength(2),
    );
    expect(
      RegExp(r'release-symbols/\*\.cms').allMatches(codemagic),
      hasLength(2),
    );
    expect(workflow, contains('openssl smime -encrypt'));
    final jobs = (loadYaml(workflow) as YamlMap)['jobs'] as YamlMap;
    final release = jobs['release'] as YamlMap;
    final releaseSteps = release['steps'] as YamlList;
    YamlMap releaseStep(String name) =>
        releaseSteps.cast<YamlMap>().singleWhere(
          (step) => step['name'] == name,
        );
    final encrypt = releaseStep('Encrypt release symbols');
    final collect = releaseStep('Collect iOS release artifacts');
    final upload = releaseStep('Upload iOS artifact');
    expect(
      encrypt['run'],
      contains('-out build/release-symbols/ios-release-symbols.cms'),
    );
    expect(
      collect['run'],
      contains(
        'symbols = Path("build/release-symbols/ios-release-symbols.cms")',
      ),
    );
    expect(collect['run'], contains('destination = Path("dist")'));
    expect(
      collect['run'],
      contains('shutil.copy2(symbols, destination / symbols.name)'),
    );
    expect((upload['with'] as YamlMap)['path'], 'dist/');
    expect(
      releaseSteps.indexOf(encrypt),
      lessThan(releaseSteps.indexOf(collect)),
    );
    expect(
      releaseSteps.indexOf(collect),
      lessThan(releaseSteps.indexOf(upload)),
    );
    expect(File('tool/release_symbols_public.pem').existsSync(), isTrue);
    expect(File('tool/decrypt_release_symbols.ps1').existsSync(), isTrue);
    expect(gitignore, contains('!tool/release_symbols_public.pem'));
    expect(
      decryptScript,
      contains('System.Security.Cryptography.ProtectedData'),
    );
    expect(decryptScript, contains('System.Security.Cryptography.Pkcs'));
    expect(project, contains('DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";'));
    expect(project, isNot(contains('DEPLOYMENT_POSTPROCESSING = YES;')));
    expect(project, isNot(contains('STRIP_INSTALLED_PRODUCT = YES;')));
  });
}
