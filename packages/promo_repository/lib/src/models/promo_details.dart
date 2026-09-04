import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:promo_repository/src/models/promo_section.dart';

part 'promo_details.freezed.dart';
part 'promo_details.g.dart';

@freezed
abstract class PromoHero with _$PromoHero {
  const factory PromoHero({
    String? badge,
    String? title,
    String? subtitle,
    @Default(<String>[]) List<String> tags,
  }) = _PromoHero;

  factory PromoHero.fromJson(Map<String, Object?> json) =>
      _$PromoHeroFromJson(json.cast());
}

@freezed
abstract class PromoContact with _$PromoContact {
  const factory PromoContact({
    String? title,
    String? subtitle,
  }) = _PromoContact;

  factory PromoContact.fromJson(Map<String, Object?> json) =>
      _$PromoContactFromJson(json.cast());
}

List<PromoSection> _sectionsFromJson(Object? value) {
  if (value is! List<Object?>) return const [];
  return [
    for (final item in value)
      if (item is Map<Object?, Object?> &&
          PromoSection.knownTypes.contains(item['type']))
        PromoSection.fromJson(item.cast()),
  ];
}

List<Object?> _sectionsToJson(List<PromoSection> sections) => [
  for (final section in sections) section.toJson(),
];

@freezed
abstract class PromoDetails with _$PromoDetails {
  const factory PromoDetails({
    PromoHero? hero,
    @JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson)
    @Default(<PromoSection>[])
    List<PromoSection> sections,
    PromoContact? contact,
    String? footnote,
  }) = _PromoDetails;

  factory PromoDetails.fromJson(Map<String, Object?> json) =>
      _$PromoDetailsFromJson(json.cast());
}
