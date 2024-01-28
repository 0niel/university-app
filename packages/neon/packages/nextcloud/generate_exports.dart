import 'dart:io';

import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:path/path.dart' as p;

void main() {
  final files = Directory('lib/src/api')
      .listSync()
      .cast<File>()
      .where((file) => file.path.endsWith('.openapi.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final idStatements = StringBuffer();

  for (final file in files) {
    final basename = p.basename(file.path);
    final id = basename.substring(0, basename.length - 13);
    final variablePrefix = toDartName(id);
    final classPrefix = toDartName(id, uppercaseFirstCharacter: true);

    idStatements
      ..writeln('  /// ID for the $id app.')
      ..writeln("  static const $variablePrefix = '$id';");

    final exports = ["export 'src/api/$id.openapi.dart';"];
    if (File('lib/src/helpers/$id.dart').existsSync()) {
      exports.add("export 'src/helpers/$id.dart';");
    }

    if (!file.readAsStringSync().contains(RegExp(r'class \$Client extends _i[0-9]*.DynamiteClient {'))) {
      File('lib/$id.dart').writeAsStringSync(exports.join('\n'));
      continue;
    }

    File('lib/$id.dart').writeAsStringSync('''
// coverage:ignore-file
import 'package:nextcloud/src/api/$id.openapi.dart';
import 'package:nextcloud/src/client.dart';

${exports.join('\n')}

// ignore: public_member_api_docs
extension ${classPrefix}Extension on NextcloudClient {
  static final _$variablePrefix = Expando<\$Client>();

  /// Client for the $id APIs
  \$Client get $variablePrefix => _$variablePrefix[this] ??= \$Client.fromClient(this);
}
''');
  }

  File('lib/ids.dart').writeAsStringSync('''
/// IDs of the apps.
final class AppIDs {
$idStatements
}
''');
}
