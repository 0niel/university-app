import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_section.freezed.dart';
part 'promo_section.g.dart';

@freezed
abstract class PromoFact with _$PromoFact {
  const factory PromoFact({
    required String label,
    @Default('') String value,
    String? emoji,
  }) = _PromoFact;

  factory PromoFact.fromJson(Map<String, Object?> json) =>
      _$PromoFactFromJson(json.cast());
}

@freezed
abstract class PromoStep with _$PromoStep {
  const factory PromoStep({
    required String title,
    @Default('') String text,
  }) = _PromoStep;

  factory PromoStep.fromJson(Map<String, Object?> json) =>
      _$PromoStepFromJson(json.cast());
}

@freezed
abstract class PromoFaqItem with _$PromoFaqItem {
  const factory PromoFaqItem({
    @JsonKey(name: 'q') required String question,
    @JsonKey(name: 'a') @Default('') String answer,
  }) = _PromoFaqItem;

  factory PromoFaqItem.fromJson(Map<String, Object?> json) =>
      _$PromoFaqItemFromJson(json.cast());
}

@freezed
abstract class PromoLink with _$PromoLink {
  const factory PromoLink({
    required String label,
    required String url,
  }) = _PromoLink;

  factory PromoLink.fromJson(Map<String, Object?> json) =>
      _$PromoLinkFromJson(json.cast());
}

@Freezed(unionKey: 'type')
sealed class PromoSection with _$PromoSection {
  @FreezedUnionValue('facts')
  const factory PromoSection.facts({
    @Default('') String title,
    @Default(<PromoFact>[]) List<PromoFact> items,
  }) = PromoFactsSection;

  @FreezedUnionValue('steps')
  const factory PromoSection.steps({
    @Default('') String title,
    @Default(<PromoStep>[]) List<PromoStep> items,
  }) = PromoStepsSection;

  @FreezedUnionValue('checklist')
  const factory PromoSection.checklist({
    @Default('') String title,
    @Default(<String>[]) List<String> items,
  }) = PromoChecklistSection;

  @FreezedUnionValue('faq')
  const factory PromoSection.faq({
    @Default('') String title,
    @Default(<PromoFaqItem>[]) List<PromoFaqItem> items,
  }) = PromoFaqSection;

  @FreezedUnionValue('text')
  const factory PromoSection.text({
    @Default('') String title,
    @Default('') String body,
  }) = PromoTextSection;

  @FreezedUnionValue('links')
  const factory PromoSection.links({
    @Default('') String title,
    @Default(<PromoLink>[]) List<PromoLink> items,
  }) = PromoLinksSection;

  const PromoSection._();

  factory PromoSection.fromJson(Map<String, Object?> json) =>
      _$PromoSectionFromJson(json.cast());

  static const knownTypes = {
    'facts',
    'steps',
    'checklist',
    'faq',
    'text',
    'links',
  };

  bool get isEmpty => switch (this) {
    PromoFactsSection(:final items) => items.isEmpty,
    PromoStepsSection(:final items) => items.isEmpty,
    PromoChecklistSection(:final items) => items.isEmpty,
    PromoFaqSection(:final items) => items.isEmpty,
    PromoTextSection(:final body) => body.trim().isEmpty,
    PromoLinksSection(:final items) => items.isEmpty,
  };
}
