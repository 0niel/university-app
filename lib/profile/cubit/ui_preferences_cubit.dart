import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';

part 'home_section.dart';
part 'ui_preferences_state.dart';
part 'ui_preferences_cubit.freezed.dart';
part 'ui_preferences_cubit.g.dart';

class UiPreferencesCubit extends HydratedCubit<UiPreferencesState> {
  UiPreferencesCubit() : super(const UiPreferencesState());

  void setSection(HomeSection section, {required bool enabled}) {
    final next = {...state.enabledSections};
    if (enabled) {
      next.add(section);
    } else {
      next.remove(section);
    }
    emit(state.copyWith(enabledSections: next));
  }

  void setShowLessonReactions({required bool value}) {
    emit(state.copyWith(showLessonReactions: value));
  }

  void setShowPromoBanners({required bool value}) {
    emit(state.copyWith(showPromoBanners: value));
  }

  void setLessonTypeColor(String lessonType, int color) {
    emit(
      state.copyWith(
        lessonTypeColors: {...state.lessonTypeColors, lessonType: color},
      ),
    );
  }

  void resetLessonTypeColors() {
    emit(state.copyWith(lessonTypeColors: kDefaultLessonTypeColors));
  }

  @override
  UiPreferencesState? fromJson(Map<String, dynamic> json) {
    try {
      return UiPreferencesState.fromJson(json);
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(UiPreferencesState state) => state.toJson();
}
