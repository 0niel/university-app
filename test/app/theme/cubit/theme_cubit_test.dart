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

    test('legacy migration preserves chosen accents and AMOLED', () {
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
            ThemeState(colorScheme: scheme, isAmoled: isAmoled),
          );
        }
      }
    });

    test('default dark theme matches both design documents', () {
      final cubit = ThemeCubit();
      final theme = cubit.getDarkTheme();
      final colors = theme.colors;
      expect(colors.canvas, const Color(0xFF0F1012));
      expect(colors.surface, const Color(0xFF1A1B20));
      expect(colors.surface2, const Color(0xFF25272E));
      expect(colors.ink, const Color(0xFFECEDEF));
      expect(colors.muted, const Color(0xFF9AA0AB));
      expect(colors.muted2, const Color(0xFF5F646E));
      expect(colors.accent, const Color(0xFF78A7FF));
      expect(colors.onAccent, const Color(0xFF0F1012));
      expect(colors.lecture, const Color(0xFF55C7A4));
      expect(colors.practice, const Color(0xFF78A7FF));
      expect(colors.lab, const Color(0xFFA18AFF));
      expect(colors.exam, const Color(0xFFFF7478));
      expect(colors.warn, const Color(0xFFF0C866));
      expect(colors.line.a, .08);
      expect(colors.scrim.a, .6);
      expect(colors.tintMix, .18);
      expect(colors.tint2Mix, .34);
      expect(theme.scaffoldBackgroundColor, colors.canvas);
      expect(theme.colorScheme.surface, colors.surface);
      expect(theme.colorScheme.surfaceContainerHighest, colors.surface2);
      expect(theme.colorScheme.surfaceTint, Colors.transparent);
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

    test(
      'bridge tokens preserve the selected design palette in every theme',
      () {
        for (final scheme in AppColorScheme.values) {
          final cubit = ThemeCubit()..setColorScheme(scheme);
          for (final amoled in [false, true]) {
            cubit.setAmoled(enabled: amoled);
            final themes = [cubit.getLightTheme(), cubit.getDarkTheme()];
            for (final theme in themes) {
              final colors = theme.extension<NinjaColors>()!;
              final appColors = theme.extension<AppColors>()!;
              final expected = theme.brightness == Brightness.dark
                  ? AppColorSchemes.getDarkColors(scheme)
                  : AppColorSchemes.getLightColors(scheme);
              expect(appColors.accent, expected.accent);
              expect(appColors.onAccent, expected.onAccent);
              expect(colors.mutedDark, expected.muted);
              expect(colors.amberInk, expected.warn);
              expect(colors.warnTint, appColors.warnTint);
              expect(colors.brandInk, expected.accent);
              expect(colors.brandTint, appColors.tint);
              expect(theme.badgeTheme.backgroundColor, expected.exam);
              expect(theme.badgeTheme.textColor, expected.white);
              expect(
                _contrast(colors.ink, colors.canvas),
                greaterThanOrEqualTo(7),
              );
            }
          }
        }
      },
    );

    test(
      'contrast helpers choose readable foregrounds independently of tokens',
      () {
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
            for (final surface in [
              palette.canvas,
              palette.surface,
              palette.surfaceAlt,
            ]) {
              expect(
                _contrast(palette.accentOn(swatch, surface), surface),
                greaterThanOrEqualTo(4.5),
              );
              expect(
                _contrast(palette.accentInk(swatch), surface),
                greaterThanOrEqualTo(4.5),
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
