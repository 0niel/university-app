import 'package:freezed_annotation/freezed_annotation.dart';

enum PromoPlacement {
  @JsonValue('home')
  home,
  @JsonValue('schedule')
  schedule,
  @JsonValue('details')
  details,
}
