import 'dart:io';

void main() {
  final props = File('lib/src/webdav/props.csv').readAsLinesSync().map((line) => line.split(','));
  final valueProps = <String>[];
  final findProps = <String>[];
  final variables = <String>[];
  for (final prop in props) {
    final namespacePrefix = prop[0];
    final namespaceVariable = convertNamespace(namespacePrefix);
    final type = prop[2];
    final name = prop[1];
    final variable = namespacePrefix + name.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
    valueProps.add(
      "@annotation.XmlElement(name: '$name', namespace: $namespaceVariable, includeIfNull: false,)\n  final $type? $variable;",
    );
    findProps.add(
      "@annotation.XmlElement(name: '$name', namespace: $namespaceVariable, includeIfNull: true, isSelfClosing: true,)\n final List<String?>? $variable;",
    );
    variables.add(variable);
  }
  File('lib/src/webdav/props.dart').writeAsStringSync(
    [
      '// ignore_for_file: public_member_api_docs',
      '// coverage:ignore-file',
      "import 'package:meta/meta.dart';",
      "import 'package:nextcloud/src/webdav/webdav.dart';",
      "import 'package:xml/xml.dart';",
      "import 'package:xml_annotation/xml_annotation.dart' as annotation;",
      "part 'props.g.dart';",
      '',
      ...generateClass(
        'WebDavPropWithoutValues',
        'prop',
        'namespaceDav',
        findProps,
        variables,
        isPropfind: true,
      ),
      ...generateClass(
        'WebDavProp',
        'prop',
        'namespaceDav',
        valueProps,
        variables,
        isPropfind: false,
      ),
      ...generateClass(
        'WebDavOcFilterRules',
        'filter-rules',
        'namespaceOwncloud',
        valueProps,
        variables,
        isPropfind: false,
      ),
      '',
    ].join('\n'),
  );
}

List<String> generateClass(
  String name,
  String elementName,
  String namespace,
  List<String> props,
  List<String> variables, {
  required bool isPropfind,
}) =>
    [
      '@immutable',
      '@annotation.XmlSerializable(createMixin: true)',
      "@annotation.XmlRootElement(name: '$elementName', namespace: $namespace)",
      'class $name with _\$${name}XmlSerializableMixin {',
      '  const $name({',
      ...variables.map((variable) => '    this.$variable,'),
      '  });',
      '',
      if (isPropfind) ...[
        '  const $name.fromBools({',
        ...variables.map((variable) => '    bool $variable = false,'),
        '  }) : ${variables.map((variable) => '$variable = $variable ? const [null] : null').join(', ')};',
        '',
      ],
      '  factory $name.fromXmlElement(XmlElement element) => _\$${name}FromXmlElement(element);',
      ...props.map((prop) => '\n  $prop'),
      '}',
    ];

String convertNamespace(String namespacePrefix) {
  switch (namespacePrefix) {
    case 'dav':
      return 'namespaceDav';
    case 'oc':
      return 'namespaceOwncloud';
    case 'nc':
      return 'namespaceNextcloud';
    case 'ocs':
      return 'namespaceOpenCollaborationServices';
    case 'ocm':
      return 'namespaceOpenCloudMesh';
    default:
      throw Exception('Unknown namespace prefix "$namespacePrefix"');
  }
}
