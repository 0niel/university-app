import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:promo_repository/src/models/promo_details.dart';
import 'package:promo_repository/src/models/promo_enums.dart';

part 'promo_banner.freezed.dart';
part 'promo_banner.g.dart';

List<PromoPlacement> _placementsFromJson(Object? value) {
  if (value is! List<Object?>) return const [PromoPlacement.home];
  return [
    for (final item in value)
      if (item == 'home')
        PromoPlacement.home
      else if (item == 'schedule')
        PromoPlacement.schedule,
  ];
}

List<String> _placementsToJson(List<PromoPlacement> placements) => [
  for (final placement in placements) placement.name,
];

@freezed
abstract class PromoBanner with _$PromoBanner {
  const factory PromoBanner({
    required String id,
    required String slug,
    required String title,
    required String ctaUrl,
    @JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson)
    @Default(<PromoPlacement>[PromoPlacement.home])
    List<PromoPlacement> placements,
    @JsonKey(unknownEnumValue: PromoHomeSlot.afterToday)
    @Default(PromoHomeSlot.afterToday)
    PromoHomeSlot homeSlot,
    @Default(0) int priority,
    @Default(1) int version,
    @JsonKey(unknownEnumValue: PromoStyle.solid)
    @Default(PromoStyle.solid)
    PromoStyle style,
    @Default('#FC3F1D') String accentColor,
    @Default('✨') String emoji,
    String? kicker,
    String? subtitle,
    @Default('Подробнее') String ctaLabel,
    @Default('Зарегистрироваться') String registerLabel,
    String? contactTelegram,
    @Default(true) bool allowSnooze,
    @Default(72) int snoozeHours,
    @Default(true) bool allowHideForever,
    @Default(PromoDetails()) PromoDetails details,
  }) = _PromoBanner;

  const PromoBanner._();

  factory PromoBanner.fromJson(Map<String, Object?> json) =>
      _$PromoBannerFromJson(json.cast());

  String get dismissKey => '$id:$version';

  Duration get snoozeDuration => Duration(hours: snoozeHours);

  bool get dismissible => allowSnooze || allowHideForever;

  bool showsOn(PromoPlacement placement) => placements.contains(placement);
}
