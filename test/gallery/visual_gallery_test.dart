@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);

  testWidgets('settings rows align their trailing edge', (tester) async {
    await _shot(
      tester,
      'visual_settings_rows',
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsSection(
              label: 'Приватность',
              children: [
                SettingsRow(
                  title: 'Видимость профиля',
                  lineIcon: AppLineIcon.view,
                  value: 'Все',
                  onTap: () {},
                ),
                SettingsToggleRow(
                  label: 'Анонимные реакции',
                  lineIcon: AppLineIcon.hide,
                  value: true,
                  onChanged: (_) {},
                ),
                SettingsToggleRow(
                  label: 'NFC-пропуск на турникете',
                  lineIcon: AppLineIcon.contactless,
                  sub: 'Прикладывайте телефон к турникету.',
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
            SettingsSection(
              label: 'Расписание',
              children: [
                SettingsRow(
                  title: 'Моя группа',
                  lineIcon: AppLineIcon.card,
                  value: 'ИКБО-02-22',
                  onTap: () {},
                ),
                SettingsRow(
                  title: 'Что на главной',
                  lineIcon: AppLineIcon.grid,
                  value: 'Все разделы',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });

  testWidgets('section label keeps its action flush right', (tester) async {
    await _shot(
      tester,
      'visual_section_label',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              28,
              NinjaMetrics.screenPadding,
              8,
            ),
            child: Builder(
              builder: (context) => Row(
                children: [
                  Expanded(
                    child: Text(
                      'Достижения',
                      style: NinjaText.title.copyWith(
                        color: context.colors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppRowTrailing(
                    child: NinjaChip(label: 'Все', onTap: () {}),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });

  testWidgets('circle icon badges keep their nominal size', (tester) async {
    await _shot(
      tester,
      'visual_icon_badges',
      Builder(
        builder: (context) {
          final colors = context.colors;
          return Padding(
            padding: const EdgeInsets.all(NinjaMetrics.screenPadding),
            child: Row(
              children: [
                for (final icon in const [
                  AppLineIcon.bell,
                  AppLineIcon.pin,
                  AppLineIcon.more,
                  AppLineIcon.info,
                  AppLineIcon.smile,
                ]) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.tint,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(
                      dimension: NinjaMetrics.minTouchTarget,
                      child: AppLineIconWidget(
                        icon,
                        size: 20,
                        color: colors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  });

  testWidgets('every line icon reads at row size', (tester) async {
    await _shot(
      tester,
      'visual_icon_sheet',
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final icon in AppLineIcon.values)
                SizedBox(
                  width: 52,
                  child: Column(
                    children: [
                      AppLineIconWidget(icon, color: context.colors.ink),
                      const SizedBox(height: 3),
                      Text(
                        icon.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.helper.copyWith(
                          fontSize: 7,
                          color: context.colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  });

  testWidgets('suspect icons hold up when enlarged', (tester) async {
    await _shot(
      tester,
      'visual_icon_zoom',
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final icon in const [
                AppLineIcon.grid,
                AppLineIcon.services,
                AppLineIcon.book,
                AppLineIcon.at,
                AppLineIcon.flask,
                AppLineIcon.swipe,
                AppLineIcon.wifiOff,
                AppLineIcon.imageOff,
                AppLineIcon.face,
                AppLineIcon.smile,
                AppLineIcon.school,
                AppLineIcon.clipboard,
                AppLineIcon.door,
                AppLineIcon.tag,
                AppLineIcon.key,
                AppLineIcon.palette,
              ])
                SizedBox(
                  width: 82,
                  child: Column(
                    children: [
                      AppLineIconWidget(
                        icon,
                        size: 64,
                        color: context.colors.ink,
                      ),
                      Text(
                        icon.name,
                        style: NinjaText.helper.copyWith(
                          fontSize: 9,
                          color: context.colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  });

  testWidgets('the navigation pill floats over the page', (tester) async {
    await _shot(
      tester,
      'visual_bottom_bar',
      Builder(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: context.colors.surface,
                child: Center(
                  child: Text(
                    'страница под панелью',
                    style: NinjaText.title.copyWith(color: context.colors.ink),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: NinjaBottomBar(
                currentIndex: 0,
                onSelected: (_) {},
                items: [
                  for (final icon in const [
                    AppLineIcon.home,
                    AppLineIcon.calendar,
                    AppLineIcon.map,
                    AppLineIcon.grid,
                    AppLineIcon.user,
                  ])
                    NinjaBottomBarItem(
                      icon: AppLineIconWidget(icon),
                      label: icon.name,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });

  testWidgets('sheet rows align with the sheet title', (tester) async {
    await _shot(
      tester,
      'visual_sheet_select',
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showAppSheet<void>(
            context,
            title: 'Видимость профиля',
            subtitle: 'Кто может найти вас в поиске и рекомендациях.',
            contentPadding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (label, selected) in const [
                  ('Все', true),
                  ('Только группа', false),
                  ('Никто', false),
                ])
                  SettingsRow(
                    title: label,
                    showChevron: false,
                    horizontalPadding: AppSpacing.xl,
                    onTap: () {},
                    trailing: NinjaRadio<bool>(
                      value: true,
                      groupValue: selected,
                      onChanged: (_) {},
                    ),
                  ),
              ],
            ),
          ),
          child: const Text('open'),
        ),
      ),
      openSheet: true,
    );
  });
}

Future<void> _shot(
  WidgetTester tester,
  String name,
  Widget child, {
  double height = 844,
  bool openSheet = false,
}) async {
  tester.view
    ..physicalSize = Size(390, height)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.colors.canvas,
          body: child,
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(seconds: 2));

  if (openSheet) {
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}
