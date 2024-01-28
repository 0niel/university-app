import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';
import 'package:version/version.dart';

/// Combination of preset `name` and preset `version`.
typedef Preset = ({String name, Version version});

final Map<String, List<Version>> _presets = () {
  final presets = <String, List<Version>>{};

  final presetGroups = Directory('../nextcloud_test/docker/presets')
      .listSync(followLinks: false)
      .whereType<Directory>()
      .map((d) => PathUri.parse(d.path).name);

  for (final presetGroup in presetGroups) {
    final presetVersions = Directory('../nextcloud_test/docker/presets/$presetGroup')
        .listSync(followLinks: false)
        .whereType<File>()
        .map((f) => Version.parse(PathUri.parse(f.path).name));

    presets[presetGroup] = presetVersions.toList();
  }

  return presets;
}();

/// All tests for apps that depend on the server version must be wrapped with this method and pass along the preset.
void presets(
  String presetGroup,
  String app,
  dynamic Function(Preset preset) body, {
  int? retry,
  Timeout? timeout,
}) {
  if (!_presets.containsKey(presetGroup)) {
    throw Exception('Unknown preset type "$presetGroup"');
  }

  void innerBody() {
    for (final presetVersion in _presets[presetGroup]!) {
      group('${presetVersion.major}.${presetVersion.minor}', () {
        final preset = (name: presetGroup, version: presetVersion);

        tearDown(() {
          validateFixture(preset);
        });

        return body(preset);
      });
    }
  }

  group(
    presetGroup,
    () {
      if (app != presetGroup) {
        group(app, innerBody);
      } else {
        innerBody();
      }
    },
    retry: retry,
    timeout: timeout,
  );
}
