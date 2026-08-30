import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('ThemeCubit', () {
    test('initial state is ThemeState()', () {
      expect(ThemeCubit().state, equals(const ThemeState()));
    });

    blocTest<ThemeCubit, ThemeState>(
      'changes the shared accent scheme',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setColorScheme(AppColorScheme.violet),
      expect: () => const <ThemeState>[
        ThemeState(colorScheme: AppColorScheme.violet),
      ],
    );

    test('toJson/fromJson round-trips the scheme + amoled flag', () {
      final cubit = ThemeCubit();
      const state = ThemeState(
        colorScheme: AppColorScheme.red,
        isAmoled: true,
      );
      final json = cubit.toJson(state);
      expect(json, {
        'colorScheme': 'red',
        'isAmoled': true,
        'accentSelectionVersion': 2,
      });
      expect(cubit.fromJson(json), equals(state));
    });

    test('migrates the previously forced green accent to blue once', () {
      final cubit = ThemeCubit();
      expect(
        cubit.fromJson({'colorScheme': 'green', 'isAmoled': true}),
        const ThemeState(isAmoled: true),
      );
      expect(
        cubit.fromJson({
          'colorScheme': 'green',
          'isAmoled': false,
          'accentSelectionVersion': 2,
        }),
        const ThemeState(colorScheme: AppColorScheme.green),
      );
    });

    test('fromJson falls back safely for invalid values', () {
      final cubit = ThemeCubit();
      expect(
        cubit.fromJson({'colorScheme': 4, 'isAmoled': false}).colorScheme,
        AppColorSchemes.defaultScheme,
      );
      expect(
        cubit.fromJson({'colorScheme': 9999, 'isAmoled': false}),
        equals(const ThemeState()),
      );
      expect(
        cubit.fromJson({'colorScheme': 'oops'}),
        equals(const ThemeState()),
      );
    });

    test('selected accent is exposed without replacing semantic colors', () {
      final cubit = ThemeCubit()..setColorScheme(AppColorScheme.violet);
      final theme = cubit.getLightTheme();
      final appColors = theme.extension<AppColors>()!;
      final ninjaColors = theme.extension<NinjaColors>()!;

      expect(
        appColors.primary,
        AppColorSchemes.getLightColors(.violet).primary,
      );
      expect(ninjaColors.brand, appColors.primary);
      expect(ninjaColors.lime, appColors.primary);
      expect(appColors.success, isNot(appColors.primary));
      expect(appColors.error, isNot(appColors.primary));
      expect(appColors.warning, isNot(appColors.primary));
    });

    test('amoled mode uses a black canvas and flat dark surfaces', () {
      final cubit = ThemeCubit()..setAmoled(enabled: true);
      final theme = cubit.getDarkTheme();
      final appColors = theme.extension<AppColors>()!;
      final ninjaColors = theme.extension<NinjaColors>()!;

      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(appColors.background01, Colors.black);
      expect(ninjaColors.canvas, Colors.black);
      expect(appColors.cardShadowDark, Colors.transparent);
    });

    test('readable bridge tokens keep accessible contrast in every theme', () {
      for (final scheme in AppColorScheme.values) {
        final cubit = ThemeCubit()..setColorScheme(scheme);
        for (final amoled in [false, true]) {
          cubit.setAmoled(enabled: amoled);
          final themes = [cubit.getLightTheme(), cubit.getDarkTheme()];
          for (final theme in themes) {
            final colors = theme.extension<NinjaColors>()!;
            final mutedContrast = _contrast(colors.mutedDark, colors.canvas);
            final warningSurface = Color.alphaBlend(
              colors.warnTint,
              colors.canvas,
            );
            final warningContrast = _contrast(
              colors.amberInk,
              warningSurface,
            );
            final appColors = theme.extension<AppColors>()!;
            final accentContrast = _contrast(
              appColors.onAccent,
              appColors.primary,
            );
            final badgeContrast = _contrast(
              theme.badgeTheme.textColor!,
              theme.badgeTheme.backgroundColor!,
            );
            final brandTintSurface = Color.alphaBlend(
              colors.brandTint,
              colors.surface,
            );
            final selectedTabSurface = Color.alphaBlend(
              colors.brand.withValues(alpha: colors.isDark ? .2 : .1),
              colors.surface,
            );

            expect(
              mutedContrast,
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
            expect(
              warningContrast,
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
            expect(
              accentContrast,
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
            expect(
              badgeContrast,
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
            expect(
              _contrast(colors.brandInk, brandTintSurface),
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
            expect(
              _contrast(colors.brandInk, selectedTabSurface),
              greaterThanOrEqualTo(4.5),
              reason: '$scheme amoled=$amoled ${theme.brightness}',
            );
          }
        }
      }

      for (final palette in [NinjaColors.light(), NinjaColors.dark()]) {
        expect(
          _contrast(palette.onScarlet, palette.scarlet),
          greaterThanOrEqualTo(4.5),
        );
        for (final swatch in const [
          Color(0xFF087F5B),
          Color(0xFF2F7AFF),
          Color(0xFF8B5CF6),
          Color(0xFFDB8B00),
          Color(0xFFE5484D),
          Color(0xFF74747D),
        ]) {
          expect(
            _contrast(palette.contrastForeground(swatch), swatch),
            greaterThanOrEqualTo(3),
          );
        }
      }
    });
  });
}

double _contrast(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
