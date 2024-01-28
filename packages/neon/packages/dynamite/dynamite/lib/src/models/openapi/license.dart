import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'license.g.dart';

abstract class License implements Built<License, LicenseBuilder> {
  factory License([void Function(LicenseBuilder) updates]) = _$License;

  const License._();

  static Serializer<License> get serializer => _$licenseSerializer;

  String get name;

  String? get identifier;

  String? get url;

  String formattedDescription({bool singleLine = true}) {
    final buffer = StringBuffer('Use of this source code is governed by a $name license.');

    if (url != null || identifier != null) {
      final url = this.url ?? 'https://spdx.org/licenses/$identifier.html';
      buffer
        ..write(singleLine ? ' ' : '\n')
        ..write('It can be obtained at `$url`.');
    }

    return buffer.toString();
  }
}
