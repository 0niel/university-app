import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/helpers/docs.dart';
import 'package:dynamite/src/models/openapi/contact.dart';
import 'package:dynamite/src/models/openapi/license.dart';

part 'info.g.dart';

abstract class Info implements Built<Info, InfoBuilder> {
  factory Info([void Function(InfoBuilder) updates]) = _$Info;

  const Info._();

  static Serializer<Info> get serializer => _$infoSerializer;

  @BuiltValueField(compare: false)
  String get title;

  String get version;

  License? get license;

  Contact? get contact;

  @BuiltValueField(compare: false)
  String? get description;

  String? get termsOfService;

  String? get summary;

  Iterable<String> formattedDescription() {
    final buffer = StringBuffer()..write('$title Version: $version');

    final summary = this.summary;
    if (summary != null && summary.isNotEmpty) {
      buffer
        ..write('\n')
        ..write(summary);
    }

    final description = this.description;
    if (description != null && description.isNotEmpty) {
      buffer
        ..write('\n\n')
        ..write(description);
    }

    final contact = this.contact;
    if (contact != null) {
      buffer
        ..write('\n\n')
        ..write(contact.formattedDescription());
    }

    final license = this.license;
    if (license != null) {
      buffer
        ..write('\n\n')
        ..write(license.formattedDescription(singleLine: false));
    }

    final termsOfService = this.termsOfService;
    if (termsOfService != null) {
      buffer
        ..write('\n\n')
        ..write('Usage of these apis must adhere to the terms of service: `$termsOfService`');
    }

    return descriptionToDocs(buffer.toString());
  }
}
