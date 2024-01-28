// This script was ported from https://github.com/git-touch/file-icon/blob/master/tool/gulpfile.esm.js and improved in many ways

import 'dart:io';

import 'package:path/path.dart' as p;

final setiUIPath = p.join(
  '..',
  '..',
  'external',
  'seti-ui',
);

void main() {
  copyFont();
  generateData();
}

void copyFont() {
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    assetsDir.createSync();
  }
  File(
    p.join(
      setiUIPath,
      'styles',
      '_fonts',
      'seti',
      'seti.ttf',
    ),
  ).copySync(p.join(assetsDir.path, 'seti.ttf'));
}

void generateData() {
  final mappingLess = File(
    p.join(
      setiUIPath,
      'styles',
      'components',
      'icons',
      'mapping.less',
    ),
  ).readAsStringSync();
  final setiLess = File(
    p.join(
      setiUIPath,
      'styles',
      '_fonts',
      'seti.less',
    ),
  ).readAsStringSync();
  final uiVariablesLess = File(
    p.join(
      setiUIPath,
      'styles',
      'ui-variables.less',
    ),
  ).readAsStringSync();

  final colors = <String, String>{'@seti-primary': '_blue'};
  final iconSet = <String, List<String>>{};
  final codePoints = <String, String>{};

  // https://github.com/microsoft/vscode/blob/554182620f43390075d8c7e7fa36634288ef4e2d/extensions/theme-seti/build/update-icon-theme.js#L345
  for (final match
      in RegExp('\\.icon-(?:set|partial)\\([\'"]([\\w-.+]+)[\'"],\\s*[\'"]([\\w-]+)[\'"],\\s*(@[\\w-]+)\\)')
          .allMatches(mappingLess)) {
    final pattern = match.group(1)!.toLowerCase();
    final type = match.group(2)!;
    final colorName = match.group(3)!;

    if (colorName != '@seti-primary') {
      colors[colorName] = '';
    }

    if (iconSet[pattern] == null) {
      iconSet[pattern] = [type, colorName];
    }
  }

  for (final match in RegExp("^\t@([a-zA-Z0-9-_]+): '\\\\([A-Z0-9]+)';\$", multiLine: true).allMatches(setiLess)) {
    codePoints[match.group(1)!] = '0x${match.group(2)!}';
  }

  for (final match
      in RegExp('^(${colors.keys.join('|')}): #([a-f0-9]+);\$', multiLine: true).allMatches(uiVariablesLess)) {
    final colorName = match.group(1)!;
    final hexCode = match.group(2)!;
    assert(hexCode.length == 6, 'CSS hex color needs to be six characters long');
    colors[colorName] = '0xff$hexCode';
  }

  final code = <String>[
    '// THIS CODE IS GENERATED - DO NOT EDIT MANUALLY',
    '',
    "import 'package:file_icons/src/meta.dart';",
    "import 'package:flutter/widgets.dart';",
    '',
    '// Code points',
    // This filters unused code points.
    for (final type in codePoints.keys
        .where((type) => iconSet.keys.map((pattern) => iconSet[pattern]![0] == type).contains(true))) ...[
      'const ${_toVariableName(type)} = ${codePoints[type]};',
    ],
    '',
    '// Colors',
    for (final colorName in colors.keys) ...[
      'const ${_toVariableName(colorName)} = ${colors[colorName]};',
    ],
    '',
    "const _fontFamily = 'Seti';",
    "const _fontPackage = 'file_icons';",
    '',
    '/// Mapping between file extensions and [IconData] and color',
    'const iconSetMap = {',
    // This filters icons where the code points are missing. That indicates the fonts in seti-ui are not up-to-date.
    // Run `gulp icons` in the seti-ui repository and everything should be there.
    // Please submit the changes upstream if you can.
    for (final pattern in iconSet.keys.where((pattern) => codePoints.keys.contains(iconSet[pattern]![0]))) ...[
      "  '$pattern': SetiMeta(",
      '    IconData(',
      '      ${_toVariableName(iconSet[pattern]![0])},',
      '      fontFamily: _fontFamily,',
      '      fontPackage: _fontPackage,',
      '    ),',
      '    ${_toVariableName(iconSet[pattern]![1])},',
      '  ),',
    ],
    '};',
    '',
  ];

  final missingCodePoints = iconSet.keys.where((pattern) => !codePoints.keys.contains(iconSet[pattern]![0]));
  if (missingCodePoints.isNotEmpty) {
    print(
      'WARNING: Missing code points for ${missingCodePoints.map((pattern) => iconSet[pattern]![0]).toSet().join(', ')}',
    );
  }

  File(
    p.join(
      'lib',
      'src',
      'data.dart',
    ),
  ).writeAsStringSync(code.join('\n'));
}

String _toVariableName(String key) {
  final result = StringBuffer('_');

  final parts = key.split('');
  for (var i = 0; i < parts.length; i++) {
    var char = parts[i];
    final prevChar = i > 0 ? parts[i - 1] : null;
    if (char == '@' || char == '-' || char == '_') {
      continue;
    }
    if (prevChar == '-' || prevChar == '_') {
      char = char.toUpperCase();
    }
    if (i == 0) {
      char = char.toLowerCase();
    }
    result.write(char);
  }

  return result.toString();
}
