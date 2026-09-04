// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromoBanner _$PromoBannerFromJson(Map<String, dynamic> json) => _PromoBanner(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  ctaUrl: json['ctaUrl'] as String,
  placements: json['placements'] == null
      ? const <PromoPlacement>[PromoPlacement.home]
      : _placementsFromJson(json['placements']),
  homeSlot:
      $enumDecodeNullable(
        _$PromoHomeSlotEnumMap,
        json['homeSlot'],
        unknownValue: PromoHomeSlot.afterToday,
      ) ??
      PromoHomeSlot.afterToday,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
  version: (json['version'] as num?)?.toInt() ?? 1,
  style:
      $enumDecodeNullable(
        _$PromoStyleEnumMap,
        json['style'],
        unknownValue: PromoStyle.solid,
      ) ??
      PromoStyle.solid,
  accentColor: json['accentColor'] as String? ?? '#FC3F1D',
  emoji: json['emoji'] as String? ?? '✨',
  kicker: json['kicker'] as String?,
  subtitle: json['subtitle'] as String?,
  ctaLabel: json['ctaLabel'] as String? ?? 'Подробнее',
  registerLabel: json['registerLabel'] as String? ?? 'Зарегистрироваться',
  contactTelegram: json['contactTelegram'] as String?,
  allowSnooze: json['allowSnooze'] as bool? ?? true,
  snoozeHours: (json['snoozeHours'] as num?)?.toInt() ?? 72,
  allowHideForever: json['allowHideForever'] as bool? ?? true,
  details: json['details'] == null
      ? const PromoDetails()
      : PromoDetails.fromJson(json['details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PromoBannerToJson(_PromoBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'ctaUrl': instance.ctaUrl,
      'placements': _placementsToJson(instance.placements),
      'homeSlot': _$PromoHomeSlotEnumMap[instance.homeSlot]!,
      'priority': instance.priority,
      'version': instance.version,
      'style': _$PromoStyleEnumMap[instance.style]!,
      'accentColor': instance.accentColor,
      'emoji': instance.emoji,
      'kicker': instance.kicker,
      'subtitle': instance.subtitle,
      'ctaLabel': instance.ctaLabel,
      'registerLabel': instance.registerLabel,
      'contactTelegram': instance.contactTelegram,
      'allowSnooze': instance.allowSnooze,
      'snoozeHours': instance.snoozeHours,
      'allowHideForever': instance.allowHideForever,
      'details': instance.details.toJson(),
    };

const _$PromoHomeSlotEnumMap = {
  PromoHomeSlot.top: 'top',
  PromoHomeSlot.afterToday: 'after_today',
  PromoHomeSlot.bottom: 'bottom',
};

const _$PromoStyleEnumMap = {
  PromoStyle.solid: 'solid',
  PromoStyle.tint: 'tint',
};
