// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_preferences_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UiPreferencesState _$UiPreferencesStateFromJson(Map<String, dynamic> json) =>
    _UiPreferencesState(
      enabledSections: json['enabledSections'] == null
          ? kAllHomeSections
          : _homeSectionsFromJson(json['enabledSections']),
      showLessonReactions: json['showLessonReactions'] as bool? ?? true,
      showPromoBanners: json['showPromoBanners'] as bool? ?? true,
      lessonTypeColors:
          (json['lessonTypeColors'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          kDefaultLessonTypeColors,
    );

Map<String, dynamic> _$UiPreferencesStateToJson(_UiPreferencesState instance) =>
    <String, dynamic>{
      'enabledSections': _homeSectionsToJson(instance.enabledSections),
      'showLessonReactions': instance.showLessonReactions,
      'showPromoBanners': instance.showPromoBanners,
      'lessonTypeColors': instance.lessonTypeColors,
    };
