// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromoFact _$PromoFactFromJson(Map<String, dynamic> json) => _PromoFact(
  label: json['label'] as String,
  value: json['value'] as String? ?? '',
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$PromoFactToJson(_PromoFact instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'emoji': instance.emoji,
    };

_PromoStep _$PromoStepFromJson(Map<String, dynamic> json) => _PromoStep(
  title: json['title'] as String,
  text: json['text'] as String? ?? '',
);

Map<String, dynamic> _$PromoStepToJson(_PromoStep instance) =>
    <String, dynamic>{'title': instance.title, 'text': instance.text};

_PromoFaqItem _$PromoFaqItemFromJson(Map<String, dynamic> json) =>
    _PromoFaqItem(
      question: json['q'] as String,
      answer: json['a'] as String? ?? '',
    );

Map<String, dynamic> _$PromoFaqItemToJson(_PromoFaqItem instance) =>
    <String, dynamic>{'q': instance.question, 'a': instance.answer};

_PromoLink _$PromoLinkFromJson(Map<String, dynamic> json) =>
    _PromoLink(label: json['label'] as String, url: json['url'] as String);

Map<String, dynamic> _$PromoLinkToJson(_PromoLink instance) =>
    <String, dynamic>{'label': instance.label, 'url': instance.url};

PromoFactsSection _$PromoFactsSectionFromJson(Map<String, dynamic> json) =>
    PromoFactsSection(
      title: json['title'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PromoFact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PromoFact>[],
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PromoFactsSectionToJson(PromoFactsSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };

PromoStepsSection _$PromoStepsSectionFromJson(Map<String, dynamic> json) =>
    PromoStepsSection(
      title: json['title'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PromoStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PromoStep>[],
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PromoStepsSectionToJson(PromoStepsSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };

PromoChecklistSection _$PromoChecklistSectionFromJson(
  Map<String, dynamic> json,
) => PromoChecklistSection(
  title: json['title'] as String? ?? '',
  items:
      (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  $type: json['type'] as String?,
);

Map<String, dynamic> _$PromoChecklistSectionToJson(
  PromoChecklistSection instance,
) => <String, dynamic>{
  'title': instance.title,
  'items': instance.items,
  'type': instance.$type,
};

PromoFaqSection _$PromoFaqSectionFromJson(Map<String, dynamic> json) =>
    PromoFaqSection(
      title: json['title'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PromoFaqItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PromoFaqItem>[],
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PromoFaqSectionToJson(PromoFaqSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };

PromoTextSection _$PromoTextSectionFromJson(Map<String, dynamic> json) =>
    PromoTextSection(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PromoTextSectionToJson(PromoTextSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'type': instance.$type,
    };

PromoLinksSection _$PromoLinksSectionFromJson(Map<String, dynamic> json) =>
    PromoLinksSection(
      title: json['title'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PromoLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PromoLink>[],
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PromoLinksSectionToJson(PromoLinksSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };
