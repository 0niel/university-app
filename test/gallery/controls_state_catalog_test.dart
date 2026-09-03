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
    for (final section in ['buttons', 'inputs', 'selection']) {
      testWidgets('controls $section ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view
          ..physicalSize = Size(800, section == 'inputs' ? 1280 : 1060)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: switch (section) {
                  'buttons' => const _Buttons(),
                  'inputs' => const _Inputs(),
                  _ => const _Selection(),
                },
              ),
            ),
          ),
        );
        await tester.pump();
        final held = <TestGesture>[];
        if (section == 'buttons') {
          for (final (index, key) in [
            'primary-pressed',
            'secondary-pressed',
          ].indexed) {
            held.add(
              await tester.startGesture(
                tester.getCenter(find.byKey(ValueKey(key))),
                pointer: index + 1,
              ),
            );
          }
        } else if (section == 'inputs') {
          tester
              .widget<AppInputField>(find.byKey(const ValueKey('focused')))
              .focusNode!
              .requestFocus();
        }
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(
            'goldens/controls_${section}_${dark ? 'dark' : 'light'}.png',
          ),
        );
        for (final gesture in held) {
          await gesture.cancel();
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}

class _Group extends StatelessWidget {
  const _Group(this.title, this.child);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppText.sectionSmall),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Кнопки', style: AppText.display),
      const SizedBox(height: 24),
      _Group(
        'Primary · состояния',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(label: 'Записаться', onPressed: () {}),
            AppButton(
              key: const ValueKey('primary-pressed'),
              label: 'Нажата',
              onPressed: () {},
            ),
            const AppButton(label: 'Загрузка', loading: true),
            const AppButton(label: 'Недоступно'),
          ],
        ),
      ),
      _Group(
        'Secondary · состояния',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton.secondary(label: 'Отмена', onPressed: () {}),
            AppButton.secondary(
              key: const ValueKey('secondary-pressed'),
              label: 'Нажата',
              onPressed: () {},
            ),
            const AppButton.secondary(label: 'Загрузка', loading: true),
            const AppButton.secondary(label: 'Недоступно'),
          ],
        ),
      ),
      _Group(
        'Tonal · Text · Destructive',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton.tonal(label: 'Подробнее', onPressed: () {}),
            AppButton.text(label: 'Все события', onPressed: () {}),
            AppButton.destructive(label: 'Удалить', onPressed: () {}),
            AppButton.destructiveOutline(label: 'Выйти', onPressed: () {}),
          ],
        ),
      ),
      _Group(
        'Размеры · Small 44 / Medium 48 / Large 52 / Hero 56',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final size in AppButtonSize.values)
              AppButton(label: size.name, size: size, onPressed: () {}),
          ],
        ),
      ),
      _Group(
        'Иконки · 16 / 20 / 24',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton(
              label: 'Добавить',
              icon: const AppLineIconWidget(AppLineIcon.plus),
              onPressed: () {},
            ),
            AppButton.secondary(
              label: 'Календарь',
              icon: const AppLineIconWidget(AppLineIcon.calendar),
              onPressed: () {},
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.plus),
              onPressed: () {},
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.plus),
              tone: AppIconButtonTone.primary,
              strokeWidth: 2.2,
              onPressed: () {},
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.search),
              shape: AppIconButtonShape.circle,
              onPressed: () {},
            ),
            const AppIconButton(icon: AppLineIconWidget(AppLineIcon.plus)),
            AppFab(icon: AppLineIcon.plus, onPressed: () {}),
          ],
        ),
      ),
      _Group(
        'Split · отдельные действия',
        AppSplitButton(
          label: 'Записаться',
          onPressed: () {},
          onMenuPressed: () {},
        ),
      ),
      _Group(
        'Совместимые обёртки',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            NinjaButton(label: 'NinjaButton', onPressed: () {}),
            NinjaIconButton(
              icon: const AppLineIconWidget(AppLineIcon.search),
              onPressed: () {},
            ),
            NinjaFab(
              icon: const AppLineIconWidget(AppLineIcon.plus),
              onPressed: () {},
            ),
          ],
        ),
      ),
      const _Group(
        'Tooltip · обе ориентации',
        Row(
          children: [
            AppTooltip(label: 'Свайпни, чтобы удалить'),
            SizedBox(width: 24),
            AppTooltip(
              label: 'Добавить в избранное',
              arrow: AppTooltipArrow.up,
            ),
          ],
        ),
      ),
    ],
  );
}

class _Inputs extends StatefulWidget {
  const _Inputs();

  @override
  State<_Inputs> createState() => _InputsState();
}

class _InputsState extends State<_Inputs> {
  final focus = FocusNode();
  final controllers = [
    TextEditingController(text: 'Олег Иванов'),
    TextEditingController(text: 'incorrect@'),
    TextEditingController(text: 'oleg@edu.mirea.ru'),
    TextEditingController(text: 'Пароль123'),
    TextEditingController(text: 'Сдать лабораторную работу до пятницы.'),
    TextEditingController(),
    TextEditingController(text: 'Математический анализ'),
    TextEditingController(text: '123'),
  ];

  @override
  void dispose() {
    focus.dispose();
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget pair(Widget left, Widget right) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: left),
      const SizedBox(width: 24),
      Expanded(child: right),
    ],
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Поля ввода', style: AppText.display),
      const SizedBox(height: 24),
      _Group(
        'Default / Focus',
        pair(
          const AppInputField(label: 'Имя', placeholder: 'Как тебя зовут?'),
          AppInputField(
            key: const ValueKey('focused'),
            label: 'В фокусе',
            controller: controllers[0],
            focusNode: focus,
          ),
        ),
      ),
      _Group(
        'Error / Success',
        pair(
          AppInputField(
            label: 'Почта',
            controller: controllers[1],
            errorText: 'Введи корректный адрес',
          ),
          AppInputField(
            label: 'Почта',
            controller: controllers[2],
            success: true,
            helperText: 'Адрес подтверждён',
          ),
        ),
      ),
      _Group(
        'Disabled / Password',
        pair(
          const AppInputField(
            label: 'Группа',
            placeholder: 'Недоступно',
            enabled: false,
          ),
          AppInputField(
            label: 'Пароль',
            controller: controllers[3],
            obscureText: true,
            showPasswordToggle: true,
          ),
        ),
      ),
      _Group(
        'Multiline / Search',
        pair(
          AppInputField.multiline(
            label: 'Заметка',
            controller: controllers[4],
            maxLength: 280,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSearchField(
                controller: controllers[5],
                hintText: 'Найти',
                trailingIcon: AppLineIcon.mic,
                onTrailingTap: () {},
              ),
              const SizedBox(height: 12),
              AppSearchField(controller: controllers[6], hintText: 'Найти'),
            ],
          ),
        ),
      ),
      _Group(
        'Select / Stepper',
        pair(
          AppSelectField(label: 'Группа', value: 'ИКБО-01-24', onTap: () {}),
          Align(
            alignment: Alignment.centerLeft,
            child: AppStepper(value: 2, max: 6, onChanged: (_) {}),
          ),
        ),
      ),
      _Group(
        'Code · заполнено / активно / пусто · адаптивные клавиши',
        pair(
          AppCodeInput(controller: controllers[7], showKeypad: true),
          const AppCodeInput(showKeypad: true, enabled: false),
        ),
      ),
    ],
  );
}

class _Selection extends StatelessWidget {
  const _Selection();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Выбор', style: AppText.display),
      const SizedBox(height: 24),
      _Group(
        'Switch · Off / On / Disabled',
        Wrap(
          spacing: 24,
          children: [
            AppSwitch(value: false, label: 'Выключено', onChanged: (_) {}),
            AppSwitch(value: true, label: 'Включено', onChanged: (_) {}),
            const AppSwitch(value: true, label: 'Недоступно'),
          ],
        ),
      ),
      _Group(
        'Checkbox · Off / On / Mixed / Disabled',
        Wrap(
          spacing: 24,
          children: [
            AppCheckbox(value: false, label: 'Пусто', onChanged: (_) {}),
            AppCheckbox(value: true, label: 'Выбрано', onChanged: (_) {}),
            AppCheckbox(
              value: false,
              indeterminate: true,
              label: 'Часть',
              onChanged: (_) {},
            ),
            const AppCheckbox(value: false, label: 'Недоступно'),
          ],
        ),
      ),
      _Group(
        'Radio · Off / On / Disabled',
        Wrap(
          spacing: 24,
          children: [
            AppRadio(value: 0, groupValue: 1, label: 'День', onChanged: (_) {}),
            AppRadio(
              value: 1,
              groupValue: 1,
              label: 'Неделя',
              onChanged: (_) {},
            ),
            const AppRadio(value: 2, groupValue: 1, label: 'Недоступно'),
          ],
        ),
      ),
      _Group(
        'Chips · Default / Selected / Dot / Count / Remove / Disabled',
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppChip(label: 'Все', onTap: () {}),
            AppChip(label: 'Учёба', selected: true, onTap: () {}),
            AppChip(label: 'События', showDot: true, onTap: () {}),
            AppChip(label: 'Новости', count: 12, onTap: () {}),
            AppChip(label: 'Выбран', selected: true, onRemove: () {}),
            const AppChip(label: 'Недоступно', enabled: false),
          ],
        ),
      ),
      _Group(
        'Screen filters',
        Wrap(
          spacing: 8,
          children: [
            AppChip.filter(label: 'Все', selected: true, onTap: () {}),
            AppChip.filter(label: 'Лекции', count: 3, onTap: () {}),
            const AppChip.filter(label: 'Недоступно', enabled: false),
          ],
        ),
      ),
      _Group(
        'Segmented · обычная поверхность',
        AppSegmentedControl(
          value: 1,
          onChanged: (_) {},
          options: const [
            AppSegmentedOption(value: 0, label: 'День'),
            AppSegmentedOption(value: 1, label: 'Неделя'),
            AppSegmentedOption(value: 2, label: 'Месяц'),
          ],
        ),
      ),
      _Group(
        'Segmented · на canvas',
        AppSegmentedControl(
          value: 0,
          onCanvas: true,
          onChanged: (_) {},
          options: const [
            AppSegmentedOption(
              value: 0,
              label: 'Список',
              icon: AppLineIcon.grid,
            ),
            AppSegmentedOption(
              value: 1,
              label: 'Календарь',
              icon: AppLineIcon.calendar,
            ),
          ],
        ),
      ),
      const _Group(
        'Segmented · disabled',
        AppSegmentedControl(
          value: 0,
          options: [
            AppSegmentedOption(value: 0, label: 'День'),
            AppSegmentedOption(value: 1, label: 'Неделя'),
          ],
        ),
      ),
      _Group(
        'Tabs · выбранная / обычная / счётчик',
        AppTabs(
          value: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          onChanged: (_) {},
          tabs: const [
            AppTab(value: 0, label: 'Сегодня'),
            AppTab(value: 1, label: 'Неделя'),
            AppTab(value: 2, label: 'События', count: 6),
          ],
        ),
      ),
    ],
  );
}
