part of 'ui_preferences_cubit.dart';

const Set<HomeSection> kAllHomeSections = {
  HomeSection.smartChips,
  HomeSection.deadlines,
  HomeSection.today,
  HomeSection.trending,
};

Set<HomeSection> _homeSectionsFromJson(Object? value) {
  if (value == null) return kAllHomeSections;
  if (value is! List<Object?>) {
    throw FormatException('enabledSections must be a list', value);
  }
  final names = value.whereType<String>().toSet();
  return HomeSection.values
      .where((section) => names.contains(section.name))
      .toSet();
}

List<String> _homeSectionsToJson(Set<HomeSection> sections) => [
  for (final section in sections) section.name,
];

@freezed
abstract class UiPreferencesState with _$UiPreferencesState {
  const factory UiPreferencesState({
    @JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson)
    @Default(kAllHomeSections)
    Set<HomeSection> enabledSections,
    @Default(true) bool showLessonReactions,
    @Default(true) bool showPromoBanners,
    @Default(kDefaultLessonTypeColors) Map<String, int> lessonTypeColors,
  }) = _UiPreferencesState;

  factory UiPreferencesState.fromJson(Map<String, dynamic> json) =>
      _$UiPreferencesStateFromJson(json);

  const UiPreferencesState._();

  bool isSectionEnabled(HomeSection section) =>
      enabledSections.contains(section);

  int lessonTypeColor(String lessonType) =>
      lessonTypeColors[lessonType] ??
      kDefaultLessonTypeColors[lessonType] ??
      kDefaultLessonTypeColors['unknown']!;
}
