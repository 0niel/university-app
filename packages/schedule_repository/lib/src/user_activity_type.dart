import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'wireValue')
enum UserActivityType {
  event('event'),
  retake('retake'),
  extra('extra'),
  personal('personal'),
  consult('consult');

  const UserActivityType(this.wireValue);

  final String wireValue;

  static UserActivityType fromWireValue(String value) {
    return UserActivityType.values.firstWhere(
      (type) => type.wireValue == value,
      orElse: () => UserActivityType.event,
    );
  }
}
