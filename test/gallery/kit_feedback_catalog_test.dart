@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final surface in [false, true]) {
      testWidgets('kit ${surface ? 'rows' : 'feedback'} catalog $dark', (
        tester,
      ) async {
        tester.view
          ..physicalSize = Size(390, surface ? 1500 : 1440)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
            home: Scaffold(
              body: Builder(
                builder: (context) => ListView(
                  padding: const EdgeInsets.all(20),
                  children: surface ? _rows(context) : _feedback(context),
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
            'goldens/kit_${surface ? 'rows' : 'feedback'}_catalog_${dark ? 'dark' : 'light'}.png',
          ),
        );
      });
    }
  }
}

List<Widget> _feedback(BuildContext context) {
  final c = context.colors;
  return [
    Text('Индикация', style: AppText.section),
    const SizedBox(height: 16),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tone in AppBadgeTone.values)
          AppBadge(label: tone.name, tone: tone, dot: tone.index >= 2),
        const AppCountBadge(3),
        const AppCountBadge(100),
        const AppDot(),
        AppTypeTag('ЛАБ', color: c.lab),
        AppTypeTag('ЛЕК', color: c.lecture),
        AppTypeTag('ПРАК', color: c.practice),
        AppTypeTag('ЭКЗ', color: c.exam),
        const AppHashTag(label: 'матан'),
      ],
    ),
    const SizedBox(height: 16),
    for (final tone in AppBannerTone.values) ...[
      AppBanner(
        message: switch (tone) {
          AppBannerTone.accent => 'Расписание обновлено 5 мин назад',
          AppBannerTone.warn => 'Офлайн · показаны сохранённые данные',
          AppBannerTone.danger => 'Пара в 12:40 отменена',
          AppBannerTone.success => 'Дедлайн закрыт',
        },
        tone: tone,
        actionLabel: tone == AppBannerTone.accent ? 'Что нового' : null,
        onAction: tone == AppBannerTone.accent ? () {} : null,
      ),
      const SizedBox(height: 8),
    ],
    const AppToast(message: 'Напомню за 15 минут'),
    const SizedBox(height: 8),
    AppToast(
      message: 'Дедлайн скрыт',
      showIcon: false,
      actionLabel: 'Вернуть',
      onAction: () {},
    ),
    const SizedBox(height: 16),
    Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const AppProgressBar(value: .25),
              const SizedBox(height: 10),
              AppProgressBar(value: .6, color: c.lecture),
              const SizedBox(height: 10),
              AppProgressBar(value: .9, color: c.danger),
            ],
          ),
        ),
        const SizedBox(width: 16),
        const AppProgressRing(value: .66, label: '66%'),
        const SizedBox(width: 16),
        const AppSpinner(),
        const SizedBox(width: 16),
        const AppPulseDot(),
      ],
    ),
    const SizedBox(height: 16),
    const AppSkeletonRow(pulse: false),
    const SizedBox(height: 16),
    const Align(
      alignment: Alignment.centerLeft,
      child: AppTooltip(label: 'Открыть подробности пары'),
    ),
    const SizedBox(height: 24),
    Text('Календарь', style: AppText.section),
    const SizedBox(height: 16),
    Row(
      children: [
        for (final variant in AppWeekGridCellVariant.values) ...[
          Expanded(
            child: AppWeekGridCell(
              variant: variant,
              topLabel: variant == AppWeekGridCellVariant.cancelled
                  ? 'ОТМ'
                  : 'ЛАБ',
              bottomLabel: 'А-318',
              selected: variant == AppWeekGridCellVariant.filled,
            ),
          ),
          if (variant != AppWeekGridCellVariant.values.last)
            const SizedBox(width: 6),
        ],
      ],
    ),
    const SizedBox(height: 16),
    Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final size in <double>[24, 28, 32, 36, 40, 44, 56, 64, 72, 88])
          AppAvatar(name: 'Анна Иванова', size: size, color: c.accent),
        const AppAvatar(name: 'Анна Иванова', size: 44, online: true),
        const AppAvatar(name: 'Анна Иванова', size: 56, levelBadge: 7),
      ],
    ),
  ];
}

List<Widget> _rows(BuildContext context) => [
  Text('Ячейки и строки', style: AppText.section),
  const SizedBox(height: 16),
  AppListGroup(
    children: [
      AppListRow(title: 'Базовая ячейка', onTap: () {}),
      AppListRow(
        title: 'С подзаголовком',
        subtitle: 'Второй строкой — мета',
        meta: 'ИКБО-01-24',
        onTap: () {},
      ),
      AppListRow(
        title: 'Уведомления',
        leading: const AppIconTile(icon: AppLineIcon.bell),
        trailing: AppSwitch(value: true, onChanged: (_) {}),
      ),
    ],
  ),
  const SizedBox(height: 16),
  for (final state in LessonRowState.values)
    AppLessonRow(
      title: 'Математический анализ',
      time: '10:40',
      endTime: '12:10',
      typeLabel: 'ЛЕК',
      chipLabel: state.name,
      state: state,
      meta: 'А-318 · Смирнова Е. В.',
      inset: 0,
      progress: state == LessonRowState.current ? .47 : null,
      color: context.colors.lecture,
    ),
  const SizedBox(height: 16),
  AppListGroup(
    children: [
      AppDeadlineRow(
        title: 'Лабораторная работа №2',
        meta: 'Физика',
        left: 'завтра',
        urgent: true,
        onToggle: () {},
      ),
      AppDeadlineRow(
        title: 'Практическая работа',
        meta: 'Программирование',
        done: true,
        left: 'готово',
        onToggle: () {},
      ),
    ],
  ),
];
