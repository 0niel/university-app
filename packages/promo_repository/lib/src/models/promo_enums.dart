import 'package:freezed_annotation/freezed_annotation.dart';

enum PromoPlacement {
  @JsonValue('home')
  home,
  @JsonValue('schedule')
  schedule,
  @JsonValue('details')
  details,
}

enum PromoHomeSlot {
  @JsonValue('top')
  top,
  @JsonValue('after_today')
  afterToday,
  @JsonValue('bottom')
  bottom,
}

enum PromoStyle {
  @JsonValue('solid')
  solid,
  @JsonValue('tint')
  tint,
}

enum PromoEvent {
  impression,
  open,
  register,
  contact,
  link,
  snooze,
  hide,
}
