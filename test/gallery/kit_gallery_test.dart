@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    testWidgets('editorial kit ${dark ? 'dark' : 'light'}', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1060)
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
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      const AppAvatar(name: 'Олег Иванов', size: 42),
                      const Spacer(),
                      AppIconButton(
                        icon: const AppLineIconWidget(AppLineIcon.search),
                        tooltip: 'Поиск',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      AppIconButton(
                        icon: const AppLineIconWidget(AppLineIcon.bell),
                        tooltip: 'Уведомления',
                        dot: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Доброе утро, Олег', style: AppText.displayMedium),
                  const SizedBox(height: 8),
                  Text('Среда, 2 сентября · 3 пары', style: AppText.caption),
                  const SizedBox(height: 20),
                  AppWeekStrip(
                    padding: EdgeInsets.zero,
                    days: const [
                      AppWeekDay('31', short: 'ПН', isPast: true),
                      AppWeekDay('1', short: 'ВТ', isPast: true),
                      AppWeekDay('2', short: 'СР', isToday: true),
                      AppWeekDay('3', short: 'ЧТ'),
                      AppWeekDay('4', short: 'ПТ'),
                      AppWeekDay('5', short: 'СБ', isWeekend: true),
                      AppWeekDay('6', short: 'ВС', isWeekend: true),
                    ],
                    selectedIndex: 2,
                    onSelected: (_) {},
                  ),
                  const SizedBox(height: 18),
                  AppCard(
                    tinted: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppChip(label: 'Следующая пара', selected: true),
                        const SizedBox(height: 14),
                        Text(
                          'Математический\nанализ',
                          style: AppText.displaySmall,
                        ),
                        const SizedBox(height: 10),
                        Text('10:40 — 12:10 · Г-402', style: AppText.body),
                        const SizedBox(height: 16),
                        AppButton.primary(
                          label: 'Открыть пару',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Расписание', style: AppText.sectionLarge),
                  const SizedBox(height: 12),
                  AppLessonRow(
                    inset: 0,
                    title: 'Программирование',
                    time: '12:40',
                    endTime: '14:10',
                    meta: 'Лабораторная · А-221',
                    color: context.colors.lab,
                    onMore: () {},
                  ),
                  const SizedBox(height: 24),
                  Text('Дедлайны', style: AppText.sectionLarge),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: AppDeadlineRow(
                      title: 'Лабораторная работа № 2',
                      meta: 'Физика · до 3 сентября',
                      left: 'завтра',
                      urgent: true,
                      onToggle: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppFilterChip(
                        label: 'Все',
                        isSelected: true,
                        onTap: () {},
                      ),
                      AppFilterChip(label: 'Лекции', onTap: () {}),
                      AppFilterChip(label: 'Практики', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: AppListRow(
                      title: 'Уведомления',
                      subtitle: 'Напоминания о занятиях',
                      trailing: AppSwitch(value: true, onChanged: (_) {}),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/editorial_kit_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
