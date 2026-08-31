import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';

part 'theme_state.freezed.dart';
part 'theme_state.g.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(AppColorScheme.blue) AppColorScheme colorScheme,
    @Default(false) bool isAmoled,
  }) = _ThemeState;

  factory ThemeState.fromJson(Map<String, dynamic> json) =>
      _$ThemeStateFromJson(json);
}
