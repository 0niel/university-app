import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'wireValue')
enum LessonMaterialType {
  note('note'),
  board('board'),
  task('task'),
  extra('extra');

  const LessonMaterialType(this.wireValue);

  final String wireValue;

  static LessonMaterialType fromWireValue(String value) {
    return LessonMaterialType.values.firstWhere(
      (type) => type.wireValue == value,
      orElse: () => LessonMaterialType.extra,
    );
  }
}
