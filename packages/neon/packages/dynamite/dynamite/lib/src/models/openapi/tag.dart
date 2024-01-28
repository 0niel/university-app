import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/helpers/docs.dart';

part 'tag.g.dart';

abstract class Tag implements Built<Tag, TagBuilder> {
  factory Tag([void Function(TagBuilder) updates]) = _$Tag;

  Tag._();

  static Serializer<Tag> get serializer => _$tagSerializer;

  String get name;

  @BuiltValueField(compare: false)
  String? get description;

  Iterable<String> get formattedDescription => descriptionToDocs(description);
}
