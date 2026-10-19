import 'package:freezed_annotation/freezed_annotation.dart';

enum PromoHomeSlot {
  @JsonValue('top')
  top,
  @JsonValue('after_today')
  afterToday,
  @JsonValue('bottom')
  bottom,
}
