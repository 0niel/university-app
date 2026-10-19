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
      final state = ThemeCubit().state;
      expect(state, equals(const ThemeState()));
      expect(state.glassEnabled, isTrue);
    });

    blocTest<ThemeCubit, ThemeState>(
      'changes the shared accent scheme',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setColorScheme(AppColorScheme.violet),
      expect: () => const <ThemeState>[
        ThemeState(colorScheme: AppColorScheme.violet),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'toggles glass without changing the chosen accent',
      build: ThemeCubit.new,
      seed: () => const ThemeState(colorScheme: AppColorScheme.violet),
      act: (cubit) => cubit
        ..setGlassEnabled(enabled: false)
        ..setGlassEnabled(enabled: true),
      expect: () => const [
        ThemeState(colorScheme: AppColorScheme.violet, glassEnabled: false),
        ThemeState(colorScheme: AppColorScheme.violet),
      ],
    );

    for (final enabled in [false, true]) {
      test('toJson/fromJson round-trips the scheme and glass $enabled', () {
        final cubit = ThemeCubit();
        final state = ThemeState(
          colorScheme: AppColorScheme.red,
          glassEnabled: enabled,
        );
        final json = cubit.toJson(state);
        expect(json, {
          'colorScheme': 'red',
          'glassEnabled': enabled,
          'accentSelectionVersion': 2,
        });
        expect(cubit.fromJson(json), equals(state));
      });
    }

    test('migrates the previously forced green accent to blue once', () {
      final cubit = ThemeCubit();
      expect(
        cubit.fromJson({'colorScheme': 'green', 'isAmoled': true}),
        const ThemeState(),
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

    test('legacy AMOLED values are ignored while chosen accents survive', () {
      final cubit = ThemeCubit();
      for (final scheme in [
        AppColorScheme.blue,
        AppColorScheme.violet,
        AppColorScheme.red,
      ]) {
        for (final isAmoled in [false, true]) {
          expect(
            cubit.fromJson({
              'colorScheme': scheme.name,
              'isAmoled': isAmoled,
            }),
            ThemeState(colorScheme: scheme),
          );
        }
      }
    });

    test(
      'default dark theme has the permanent black canvas and current palette',
      () {
        final cubit = ThemeCubit();
        final theme = cubit.getDarkTheme();
        final colors = theme.colors;
        expect(colors.canvas, Colors.black);
        expect(colors.surface, const Color(0xFF101012));
        expect(colors.surface2, const Color(0xFF1B1C21));
        expect(colors.ink, const Color(0xFFF5F7FC));
        expect(colors.muted, const Color(0xFFA0AABC));
        expect(colors.muted2, const Color(0xFF5F646E));
        expect(colors.accent, const Color(0xFFA8C4FF));
        expect(colors.onAccent, const Color(0xFF0D1830));
        expect(colors.lecture, const Color(0xFF69D8BA));
        expect(colors.practice, const Color(0xFFA8C4FF));
        expect(colors.lab, const Color(0xFFB7A0FF));
        expect(colors.exam, const Color(0xFFFF718F));
        expect(colors.warn, const Color(0xFFFFB56D));
        expect(colors.line.a, .08);
        expect(colors.scrim.a, .6);
        expect(colors.tintMix, .18);
        expect(colors.tint2Mix, .34);
        expect(theme.scaffoldBackgroundColor, colors.canvas);
        expect(theme.colorScheme.surface, colors.surface);
        expect(theme.colorScheme.surfaceContainerHighest, colors.surface2);
        expect(theme.colorScheme.surfaceTint, Colors.transparent);
        expect(theme.extension<AppGlassTheme>()!.enabled, isTrue);
      },
    );

    test('fromJson falls back safely for invalid values', () {
      final cubit = ThemeCubit();
      expect(
        cubit.fromJson({'colorScheme': 4, 'glassEnabled': false}).colorScheme,
        AppColorSchemes.defaultScheme,
      );
      expect(
        cubit.fromJson({'colorScheme': 9999, 'glassEnabled': false}),
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

      expect(
        appColors.primary,
        AppColorSchemes.getLightColors(.violet).primary,
      );
      expect(appColors.success, isNot(appColors.primary));
      expect(appColors.error, isNot(appColors.primary));
      expect(appColors.warning, isNot(appColors.primary));
    });

    test('legacy migration preserves an explicit glass preference', () {
      final cubit = ThemeCubit();
      for (final glassEnabled in [false, true]) {
        for (final isAmoled in [false, true]) {
          expect(
            cubit.fromJson({
              'colorScheme': 'green',
              'isAmoled': isAmoled,
              'glassEnabled': glassEnabled,
            }),
            ThemeState(glassEnabled: glassEnabled),
          );
        }
      }
    });

    test('glass defaults on when old storage has no appearance preference', () {
      final cubit = ThemeCubit();
      expect(cubit.fromJson({}), const ThemeState());
      expect(cubit.fromJson({'isAmoled': 'obsolete'}), const ThemeState());
    });

    test('a malformed glass value falls back to the default state', () {
      final cubit = ThemeCubit();
      expect(
        cubit.fromJson({'colorScheme': 'red', 'glassEnabled': 'invalid'}),
        const ThemeState(),
      );
    });

    test('dark surfaces stay black when glass is disabled', () {
      final cubit = ThemeCubit()..setGlassEnabled(enabled: false);
      final theme = cubit.getDarkTheme();
      final appColors = theme.extension<AppColors>()!;

      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(appColors.background01, Colors.black);
      expect(appColors.canvas, Colors.black);
      expect(appColors.cardShadowDark, Colors.transparent);
      expect(theme.extension<AppGlassTheme>()!.enabled, isFalse);
    });

    test(
      'theme tokens preserve the selected design palette in every theme',
      () {
        for (final scheme in AppColorScheme.values) {
          final cubit = ThemeCubit()..setColorScheme(scheme);
          for (final glassEnabled in [false, true]) {
            cubit.setGlassEnabled(enabled: glassEnabled);
            final themes = [cubit.getLightTheme(), cubit.getDarkTheme()];
            for (final theme in themes) {
              final appColors = theme.extension<AppColors>()!;
              final expected = theme.brightness == Brightness.dark
                  ? AppColorSchemes.getDarkColors(scheme)
                  : AppColorSchemes.getLightColors(scheme);
              expect(appColors.accent, expected.accent);
              expect(appColors.onAccent, expected.onAccent);
              expect(appColors.muted, expected.muted);
              expect(appColors.warn, expected.warn);
              expect(theme.badgeTheme.backgroundColor, expected.exam);
              expect(theme.badgeTheme.textColor, expected.white);
              expect(theme.extension<AppGlassTheme>()!.enabled, glassEnabled);
              expect(
                _contrast(appColors.ink, appColors.canvas),
                greaterThanOrEqualTo(7),
              );
            }
          }
        }
      },
    );
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
