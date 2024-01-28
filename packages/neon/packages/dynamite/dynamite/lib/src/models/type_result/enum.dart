part of 'type_result.dart';

@immutable
class TypeResultEnum extends TypeResult {
  TypeResultEnum(
    super.className,
    this.subType, {
    super.nullable,
    super.isTypeDef,
  });

  final TypeResult subType;

  @override
  String? get _builderFactory => null;

  @override
  bool operator ==(Object other) =>
      other is TypeResultEnum && other.className == className && other.generics == generics && other.subType == subType;

  @override
  int get hashCode => className.hashCode + generics.hashCode + subType.hashCode;
}
