part of 'type_result.dart';

@immutable
class TypeResultMap extends TypeResult {
  TypeResultMap(
    super.className,
    TypeResult subType, {
    super.nullable,
    super.isTypeDef,
    super.builderName = 'MapBuilder',
  }) : super(generics: BuiltList([TypeResultBase('String'), subType]));

  TypeResult get subType => generics[1];

  @override
  String? get _serializer => null;

  @override
  TypeResultMap get dartType => TypeResultMap('Map', subType, nullable: nullable);

  @override
  bool operator ==(Object other) =>
      other is TypeResultMap && other.className == className && other.generics == generics && other.subType == subType;

  @override
  int get hashCode => className.hashCode + generics.hashCode + subType.hashCode;
}
