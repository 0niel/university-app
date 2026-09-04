// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromoHero _$PromoHeroFromJson(Map<String, dynamic> json) => _PromoHero(
  badge: json['badge'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$PromoHeroToJson(_PromoHero instance) =>
    <String, dynamic>{
      'badge': instance.badge,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'tags': instance.tags,
    };

_PromoContact _$PromoContactFromJson(Map<String, dynamic> json) =>
    _PromoContact(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$PromoContactToJson(_PromoContact instance) =>
    <String, dynamic>{'title': instance.title, 'subtitle': instance.subtitle};

_PromoDetails _$PromoDetailsFromJson(Map<String, dynamic> json) =>
    _PromoDetails(
      hero: json['hero'] == null
          ? null
          : PromoHero.fromJson(json['hero'] as Map<String, dynamic>),
      sections: json['sections'] == null
          ? const <PromoSection>[]
          : _sectionsFromJson(json['sections']),
      contact: json['contact'] == null
          ? null
          : PromoContact.fromJson(json['contact'] as Map<String, dynamic>),
      footnote: json['footnote'] as String?,
    );

Map<String, dynamic> _$PromoDetailsToJson(_PromoDetails instance) =>
    <String, dynamic>{
      'hero': instance.hero?.toJson(),
      'sections': _sectionsToJson(instance.sections),
      'contact': instance.contact?.toJson(),
      'footnote': instance.footnote,
    };
