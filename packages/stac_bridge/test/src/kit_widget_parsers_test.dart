import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_widget_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  group('token colours', () {
    testWidgets('map every named token and keep hex support', (tester) async {
      final context = await pumpKit(tester, const StacAppTextParser(), {
        'data': 'x',
      });
      final colors = context.colors;
      expect(parseAppColor(context, 'examTint'), colors.examTint);
      expect(parseAppColor(context, 'lectureTint'), colors.lectureTint);
      expect(parseAppColor(context, 'muted2'), colors.muted2);
      expect(parseAppColor(context, 'surface2'), colors.surface2);
      expect(parseAppColor(context, 'line'), colors.line);
      expect(parseAppColor(context, 'danger'), colors.danger);
      expect(parseAppColor(context, 'successTint'), colors.successTint);
      expect(parseAppColor(context, 'onAccent'), colors.onAccent);
      expect(parseAppColor(context, '#123456'), const Color(0xFF123456));
      expect(parseAppColor(context, 'nope'), isNull);
    });
  });

  group('buttons', () {
    testWidgets('appButton maps variant, size, loading and disabled', (
      tester,
    ) async {
      await pumpKit(tester, const StacAppButtonParser(), {
        'label': 'Сохранить',
        'variant': 'tonal',
        'size': 'large',
        'loading': true,
        'icon': 'check',
        'onPressed': {'actionType': 'none'},
      });
      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.variant, AppButtonVariant.tonal);
      expect(button.size, AppButtonSize.large);
      expect(button.loading, isTrue);
      expect(button.icon, isA<AppLineIconWidget>());
      expect(button.onPressed, isNotNull);

      await pumpKit(tester, const StacAppButtonParser(), {
        'label': 'Нельзя',
        'enabled': false,
        'onPressed': {'actionType': 'none'},
      });
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
    });

    testWidgets('appIconButton and appFab render kit controls', (
      tester,
    ) async {
      await pumpKit(tester, const StacAppIconButtonParser(), {
        'icon': 'bell',
        'tone': 'tonal',
        'shape': 'circle',
        'dot': true,
      });
      final icon = tester.widget<AppIconButton>(find.byType(AppIconButton));
      expect(icon.tone, AppIconButtonTone.tonal);
      expect(icon.shape, AppIconButtonShape.circle);
      expect(icon.dot, isTrue);

      await pumpKit(tester, const StacAppFabParser(), {
        'icon': 'plus',
        'label': 'Создать',
        'onPressed': {'actionType': 'none'},
      });
      expect(find.byType(AppFab), findsOneWidget);
      expect(find.text('Создать'), findsOneWidget);
    });
  });

  group('inputs and selection', () {
    testWidgets('appInputField supports multiline, errors and disabled', (
      tester,
    ) async {
      await pumpKit(tester, const StacAppInputFieldParser(), {
        'label': 'Заметка',
        'multiline': true,
        'maxLength': 120,
      });
      expect(find.byType(AppInputField), findsOneWidget);

      await pumpKit(tester, const StacAppInputFieldParser(), {
        'label': 'Группа',
        'errorText': 'Нет такой группы',
        'enabled': false,
      });
      final field = tester.widget<AppInputField>(find.byType(AppInputField));
      expect(field.errorText, 'Нет такой группы');
      expect(field.enabled, isFalse);
    });

    testWidgets('appSearchField writes its query into the state scope', (
      tester,
    ) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppSearchFieldParser(), {
        'placeholder': 'Поиск',
        'stateKey': 'q',
      }, store: store);
      expect(find.byType(AppSearchField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'физика');
      expect(store.get('q'), 'физика');
    });

    testWidgets('appSelectField resolves the option label from state', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'plan': 'week'});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppSelectFieldParser(), {
        'label': 'Период',
        'stateKey': 'plan',
        'options': [
          {'value': 'day', 'label': 'День'},
          {'value': 'week', 'label': 'Неделя'},
        ],
      }, store: store);
      final select = tester.widget<AppSelectField>(
        find.byType(AppSelectField),
      );
      expect(select.value, 'Неделя');
      expect(select.onTap, isNotNull);
    });

    testWidgets('appStepper, appToggle and appCheckbox mutate state', (
      tester,
    ) async {
      final store = MiniAppStateStore()
        ..seed({'qty': 1, 'push': false, 'agree': false});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppStepperParser(), {
        'stateKey': 'qty',
        'min': 1,
        'max': 5,
      }, store: store);
      await tester.tap(find.bySemanticsLabel('+'));
      await tester.pumpAndSettle();
      expect(store.get('qty'), 2);

      await pumpKit(tester, const StacAppToggleParser(), {
        'stateKey': 'push',
        'label': 'Пуши',
      }, store: store);
      await tester.tap(
        find
            .descendant(
              of: find.byType(AppSwitch),
              matching: find.byType(AppPressState),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(store.get('push'), isTrue);

      await pumpKit(tester, const StacAppCheckboxParser(), {
        'stateKey': 'agree',
        'label': 'Согласен',
      }, store: store);
      await tester.tap(
        find
            .descendant(
              of: find.byType(AppCheckbox),
              matching: find.byType(AppPressState),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(store.get('agree'), isTrue);
    });

    testWidgets('disabled toggle keeps onChanged null', (tester) async {
      await pumpKit(tester, const StacAppSwitchParser(), {
        'value': true,
        'enabled': false,
      });
      expect(
        tester.widget<AppSwitch>(find.byType(AppSwitch)).onChanged,
        isNull,
      );
    });

    testWidgets('appRadio selects its value into the state scope', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'plan': 'free'});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppRadioParser(), {
        'stateKey': 'plan',
        'value': 'pro',
        'label': 'Про',
      }, store: store);
      final radio = tester.widget<AppRadio<String>>(
        find.byType(AppRadio<String>),
      );
      expect(radio.groupValue, 'free');
      await tester.tap(find.byType(AppRadio<String>));
      await tester.pumpAndSettle();
      expect(store.get('plan'), 'pro');
    });

    testWidgets('chips, chip rows, segments and tabs render kit widgets', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'tab': 'a', 'day': 'mon'});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppChipParser(), {
        'label': 'Матан',
        'style': 'tinted',
        'stateKey': 'tab',
        'value': 'a',
        'count': 3,
        'onRemove': {'actionType': 'none'},
      }, store: store);
      final chip = tester.widget<AppChip>(find.byType(AppChip));
      expect(chip.style, AppChipStyle.tinted);
      expect(chip.selected, isTrue);
      expect(chip.count, 3);
      expect(chip.onRemove, isNotNull);

      await pumpKit(tester, const StacAppChipRowParser(), {
        'stateKey': 'day',
        'items': [
          {'value': 'mon', 'label': 'Пн'},
          {'value': 'tue', 'label': 'Вт'},
        ],
      }, store: store);
      expect(find.byType(AppChipRow<String>), findsOneWidget);
      await tester.tap(find.text('Вт'));
      await tester.pumpAndSettle();
      expect(store.get('day'), 'tue');

      await pumpKit(tester, const StacAppSegmentedControlParser(), {
        'selectedIndex': 1,
        'options': [
          {'label': 'День'},
          {
            'label': 'Неделя',
            'child': {'type': 'appText', 'data': 'Неделя выбрана'},
          },
        ],
      });
      expect(find.byType(AppSegmentedControl<int>), findsOneWidget);
      expect(find.text('Неделя выбрана'), findsOneWidget);

      await pumpKit(tester, const StacAppTabsParser(), {
        'tabs': [
          {'label': 'Все', 'count': 12},
          {'label': 'Мои'},
        ],
      });
      expect(find.byType(NinjaTabs<int>), findsOneWidget);
    });
  });

  group('feedback', () {
    testWidgets('labels and badges map tones to kit enums', (tester) async {
      await pumpKit(tester, const StacAppBadgeParser(), {
        'label': 'Отменена',
        'tone': 'danger',
        'dot': true,
      });
      final badge = tester.widget<AppBadge>(find.byType(AppBadge));
      expect(badge.tone, AppBadgeTone.exam);
      expect(badge.dot, isTrue);

      await pumpKit(tester, const StacAppCountBadgeParser(), {'count': 120});
      expect(find.text('99+'), findsOneWidget);

      await pumpKit(tester, const StacAppTypeTagParser(), {
        'label': 'ЛЕК',
        'color': 'lecture',
      });
      expect(find.byType(AppTypeTag), findsOneWidget);

      await pumpKit(tester, const StacAppHashTagParser(), {'label': '#матан'});
      expect(find.byType(AppHashTag), findsOneWidget);

      await pumpKit(tester, const StacAppMetaPillParser(), {
        'text': 'А-401',
        'icon': 'pin',
      });
      expect(
        tester.widget<AppMetaPill>(find.byType(AppMetaPill)).icon,
        isNotNull,
      );
    });

    testWidgets('banners, tooltips and progress use kit widgets', (
      tester,
    ) async {
      await pumpKit(tester, const StacAppBannerParser(), {
        'message': 'Офлайн',
        'tone': 'warn',
      });
      expect(
        tester.widget<AppBanner>(find.byType(AppBanner)).tone,
        AppBannerTone.warn,
      );

      await pumpKit(tester, const StacAppBannerParser(), {
        'title': 'Дедлайн',
        'message': 'Завтра',
        'tone': 'danger',
      });
      expect(find.byType(NinjaBanner), findsOneWidget);

      await pumpKit(tester, const StacAppTooltipParser(), {
        'label': 'Подсказка',
      });
      expect(find.byType(AppTooltip), findsOneWidget);

      await pumpKit(tester, const StacAppProgressBarParser(), {
        'indeterminate': true,
      });
      expect(
        tester
            .widget<NinjaProgressBar>(find.byType(NinjaProgressBar))
            .indeterminate,
        isTrue,
      );

      await pumpKit(tester, const StacAppSpinnerParser(), {'size': 20});
      expect(find.byType(NinjaSpinner), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('skeletons and states render kit placeholders', (
      tester,
    ) async {
      await pumpKit(tester, const StacAppSkeletonParser(), {'variant': 'row'});
      expect(find.byType(AppSkeletonRow), findsOneWidget);

      await pumpKit(tester, const StacAppSkeletonParser(), {
        'variant': 'avatar',
      });
      expect(find.byType(NinjaSkeleton), findsOneWidget);

      await pumpKit(tester, const StacAppEmptyStateParser(), {
        'title': 'Пусто',
        'compact': true,
      });
      expect(
        tester.widget<AppEmptyState>(find.byType(AppEmptyState)).compact,
        isTrue,
      );

      await pumpKit(tester, const StacAppErrorStateParser(), {
        'title': 'Не загрузилось',
        'onPrimary': {'actionType': 'none'},
      });
      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('surfaces and lists', () {
    testWidgets('cards, groups, rows and dividers', (tester) async {
      await pumpKit(tester, const StacAppCardParser(), {
        'tinted': true,
        'child': {'type': 'appText', 'data': 'Совет'},
      });
      expect(tester.widget<AppCard>(find.byType(AppCard)).tinted, isTrue);

      await pumpKit(tester, const StacAppListGroupParser(), {
        'children': [
          {
            'type': 'appListRow',
            'title': 'Физика',
            'icon': 'flask',
            'meta': '10:40',
            'destructive': true,
          },
          {'type': 'appDivider', 'inset': true},
        ],
      });
      expect(find.byType(AppListGroup), findsOneWidget);
      final row = tester.widget<AppListRow>(find.byType(AppListRow));
      expect(row.leading, isA<AppIconTile>());
      expect(row.meta, '10:40');
      expect(row.destructive, isTrue);
      expect(find.byType(AppDivider), findsWidgets);
    });

    testWidgets('avatars, icons and media', (tester) async {
      await pumpKit(tester, const StacAppAvatarParser(), {
        'name': 'Иван Петров',
        'levelBadge': 7,
        'online': true,
      });
      final avatar = tester.widget<AppAvatar>(find.byType(AppAvatar));
      expect(avatar.levelBadge, 7);
      expect(avatar.online, isTrue);

      await pumpKit(tester, const StacAppAvatarStackParser(), {
        'names': ['А', 'Б', 'В'],
        'extra': 4,
      });
      expect(find.byType(AppAvatarStack), findsOneWidget);

      await pumpKit(tester, const StacAppIconTileParser(), {
        'icon': 'book',
        'color': 'lab',
      });
      expect(find.byType(AppIconTile), findsOneWidget);

      await pumpKit(tester, const StacAppImageParser(), {'src': 'broken'});
      expect(find.byType(ImagePlaceholder), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('typography helpers pick kit styles', (tester) async {
      await pumpKit(tester, const StacAppTextParser(), {
        'data': 'заголовок',
        'variant': 'overline',
      });
      expect(find.text('ЗАГОЛОВОК'), findsOneWidget);

      await pumpKit(tester, const StacAppOverlineParser(), {
        'label': 'Сегодня',
      });
      expect(find.byType(AppOverline), findsOneWidget);

      await pumpKit(tester, const StacAppSectionTitleParser(), {
        'title': 'Топ',
        'meta': '12 шт',
      });
      expect(find.text('12 шт'), findsOneWidget);

      await pumpKit(tester, const StacAppExpandableTextParser(), {
        'text': 'Длинный текст',
      });
      expect(find.byType(AppExpandableText), findsOneWidget);

      await pumpKit(tester, const StacAppServiceTileParser(), {
        'icon': 'map',
        'label': 'Карта',
        'color': 'practice',
      });
      expect(find.byType(AppServiceTile), findsOneWidget);

      await pumpKit(tester, const StacAppSmartChipParser(), {
        'icon': 'clock',
        'label': 'До пары',
        'value': '12 мин',
        'tone': 'warn',
      });
      expect(find.byType(AppSmartChip), findsOneWidget);
    });
  });

  group('calendar', () {
    testWidgets('week strip, deadline and lesson rows bind to state', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'day': 0, 'done': false});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppWeekStripParser(), {
        'stateKey': 'day',
        'days': [
          {
            'label': '1',
            'short': 'пн',
            'today': true,
            'dots': ['accent'],
          },
          {'label': '2', 'short': 'вт', 'weekend': false},
        ],
      }, store: store);
      expect(find.byType(NinjaWeekStrip), findsOneWidget);
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      expect(store.get('day'), 1);

      await pumpKit(tester, const StacAppDeadlineRowParser(), {
        'title': 'Лаба 3',
        'meta': 'Физика',
        'left': '2 дня',
        'stateKey': 'done',
      }, store: store);
      expect(find.byType(AppDeadlineRow), findsOneWidget);
      await tester.tap(find.byType(AppDeadlineCheck));
      await tester.pumpAndSettle();
      expect(store.get('done'), isTrue);

      await pumpKit(tester, const StacAppLessonRowParser(), {
        'title': 'Матанализ',
        'time': '10:40',
        'endTime': '12:10',
        'state': 'current',
        'progress': 0.4,
        'color': 'lecture',
      });
      final row = tester.widget<NinjaLessonRow>(find.byType(NinjaLessonRow));
      expect(row.state, LessonRowState.current);
    });

    testWidgets('calendar month writes the picked day as ISO date', (
      tester,
    ) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      await pumpKit(tester, const StacAppCalendarMonthParser(), {
        'month': '2026-09',
        'stateKey': 'date',
        'marks': {
          '2026-09-15': ['exam'],
        },
      }, store: store);
      expect(find.byType(AppCalendarMonth), findsOneWidget);
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(store.get('date'), '2026-09-15');
    });
  });
}
