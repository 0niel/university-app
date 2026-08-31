@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

/// Renders the state surfaces for a read against `options/7k.html` (weekend,
/// offline, empty) and `options/8j.html` (the state components themselves).
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('Inter');
    for (final weight in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
    ]) {
      loader.addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Inter/Inter-$weight.ttf',
        ),
      );
    }
    await loader.load();
  });

  Future<void> sheet(
    WidgetTester tester,
    String name,
    Widget child, {
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 820)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.ninja.canvas,
            body: child,
          ),
        ),
      ),
    );
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('7k · states', (tester) async {
    await sheet(
      tester,
      'states_7k',
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const NinjaDisplayHeader(
            title: 'Воскресенье,\n17 августа',
            summary: 'пар нет · выходной',
          ),
          const SizedBox(height: 20),
          const DecoratedBox(
            decoration: BoxDecoration(),
            child: NinjaEmptyState.screen(
              title: 'Отдыхайте',
              message: 'ближайшая пара — пн 8:30 · История · 207 В',
              actionLabel: 'Посмотреть понедельник',
              outlinedAction: true,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: NinjaBanner(
              tone: NinjaBannerTone.warn,
              title: 'Оффлайн · показаны данные на 9:40',
              actionLabel: 'повторить',
              onAction: () {},
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: NinjaErrorState(
              title: 'Не удалось загрузить',
              message: 'Проверьте соединение и попробуйте ещё раз',
              retryLabel: 'Повторить',
              onRetry: () {},
            ),
          ),
          const SizedBox(height: 24),
          NinjaEmptyState.screen(
            title: 'По фильтру «документы» пусто',
            message:
                'Оставьте заявку — пришлём уведомление, '
                'когда появится совпадение',
            actionLabel: 'Я что-то потерял',
            onAction: () {},
          ),
        ],
      ),
    );
  });
}
