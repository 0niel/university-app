part of 'type_result.dart';

@immutable
class TypeResultList extends TypeResult {
  TypeResultList(
    super.className,
    TypeResult subType, {
    super.nullable,
    super.isTypeDef,
    super.builderName = 'ListBuilder',
  }) : super(generics: BuiltList([subType]));

  TypeResult get subType => generics.first;

  @override
  String? get _serializer => null;

  @override
  TypeResultList get dartType => TypeResultList('List', subType, nullable: nullable);

  @override
  bool operator ==(Object other) =>
      other is TypeResultList && other.className == className && other.generics == generics && other.subType == subType;

  @override
  int get hashCode => className.hashCode + generics.hashCode + subType.hashCode;
}
