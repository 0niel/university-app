import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_appearance.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_card.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_theme_row.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  Widget wrap(Widget child, {double textScale = 1}) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(width: 320, child: child),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('theme previews remain usable at 200 percent text', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        SettingsThemeRow(
          mode: AdaptiveThemeMode.system,
          onChanged: (_) {},
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Тема'), findsOneWidget);
    await tester.tap(find.text('Авто'));
    await tester.pumpAndSettle();
    expect(find.text('Светлая'), findsWidgets);
    expect(find.text('Тёмная'), findsWidgets);
    expect(find.text('Авто'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('setting row wraps long content without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const SettingsRow(
          title: 'Очень длинное название настройки приложения',
          subtitle: 'Подробное объяснение поведения этой настройки',
          value: 'Длинное значение',
          icon: Icons.settings_rounded,
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('settings sections group their rows into one surface card', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const SettingsSection(
          label: 'Конфиденциальность',
          children: [
            SettingsRow(
              title: 'Кто видит профиль',
              lineIcon: AppLineIcon.view,
            ),
            SettingsRow(
              title: 'Анонимные реакции',
              lineIcon: AppLineIcon.shield,
            ),
          ],
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();

    final colors = tester.element(find.byType(SettingsCard)).colors;
    final card = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(SettingsCard),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = card.decoration as BoxDecoration;
    expect(decoration.color, colors.surface);
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNull);
    expect(decoration.gradient, isNull);
    expect(
      decoration.borderRadius,
      BorderRadius.circular(AppRadius.card),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('light appearance settings stay compact and brand-consistent', (
    tester,
  ) async {
    final themeCubit = ThemeCubit();
    final preferencesCubit = UiPreferencesCubit();
    addTearDown(themeCubit.close);
    addTearDown(preferencesCubit.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: preferencesCubit),
        ],
        child: MaterialApp(
          theme: themeCubit.getLightTheme(),
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(320, 568),
              textScaler: TextScaler.linear(2),
              accessibleNavigation: true,
            ),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SettingsAppearance(),
                      SettingsAdvancedAppearance(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Акцент'), findsOneWidget);
    expect(find.text('Цвета типов занятий'), findsOneWidget);
    expect(find.text('🎨'), findsNothing);
    await tester.ensureVisible(find.text('Акцент'));
    await tester.tap(find.text('Акцент'));
    await tester.pumpAndSettle();

    expect(find.text('Голубой'), findsOneWidget);
    expect(find.text('Фиолетовый'), findsOneWidget);
    await tester.tap(find.text('Фиолетовый'));
    await tester.pumpAndSettle();
    expect(themeCubit.state.colorScheme, AppColorScheme.violet);
    Navigator.of(tester.element(find.text('Фиолетовый'))).pop();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Цвета типов занятий'));
    await tester.tap(find.text('Цвета типов занятий'));
    await tester.pumpAndSettle();

    expect(find.text('Лекция'), findsOneWidget);
    expect(find.text('Экзамен'), findsOneWidget);
    expect(find.bySemanticsLabel('Лекция, Янтарный'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('#[0-9A-F]{6}')), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.selected != null,
      ),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });
}
