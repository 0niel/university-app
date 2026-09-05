import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/material_feedback_actions.dart';
import 'package:stac_bridge/src/actions/stac_confirm_action_parser.dart';
import 'package:stac_bridge/src/widgets/async_action_builder.dart';
import 'package:stac_bridge/src/widgets/material/material_override_parsers.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

Future<BuildContext> _pumpHost(WidgetTester tester) async {
  late BuildContext context;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (value) {
          context = value;
          return const Scaffold(body: SizedBox());
        },
      ),
    ),
  );
  return context;
}

void main() {
  testWidgets('material buttons render kit buttons', (tester) async {
    await pumpKit(tester, const StacElevatedButtonKitParser(), {
      'child': {'type': 'text', 'data': 'Записаться'},
      'onPressed': {'actionType': 'none'},
    });
    var button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.label, 'Записаться');
    expect(button.variant, AppButtonVariant.primary);
    expect(find.byType(ElevatedButton), findsNothing);

    await pumpKit(tester, const StacOutlinedButtonKitParser(), {
      'child': {'type': 'text', 'data': 'Отмена'},
    });
    button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.variant, AppButtonVariant.secondary);
    expect(button.onPressed, isNull);

    await pumpKit(tester, const StacTextButtonKitParser(), {
      'child': {'type': 'text', 'data': 'Ещё'},
    });
    expect(
      tester.widget<AppButton>(find.byType(AppButton)).variant,
      AppButtonVariant.text,
    );

    await pumpKit(tester, const StacIconButtonKitParser(), {
      'icon': {'type': 'icon', 'icon': 'share'},
      'onPressed': {'actionType': 'none'},
    });
    expect(find.byType(AppIconButton), findsOneWidget);
    expect(find.byType(AppLineIconWidget), findsOneWidget);
    expect(find.byType(IconButton), findsNothing);

    await pumpKit(tester, const StacFloatingActionButtonKitParser(), {
      'buttonType': 'extended',
      'icon': {'type': 'icon', 'icon': 'add'},
      'child': {'type': 'text', 'data': 'Создать'},
    });
    expect(find.byType(AppFab), findsOneWidget);
    expect(find.text('Создать'), findsOneWidget);
  });

  testWidgets('material surfaces render kit surfaces', (tester) async {
    await pumpKit(tester, const StacCardKitParser(), {
      'child': {'type': 'text', 'data': 'Внутри'},
    });
    expect(find.byType(AppCard), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    await pumpKit(tester, const StacListTileKitParser(), {
      'title': {'type': 'text', 'data': 'Физика'},
      'subtitle': {'type': 'text', 'data': 'А-401'},
      'onTap': {'actionType': 'none'},
    });
    final row = tester.widget<AppListRow>(find.byType(AppListRow));
    expect(row.title, 'Физика');
    expect(row.subtitle, 'А-401');
    expect(find.byType(ListTile), findsNothing);

    await pumpKit(tester, const StacChipKitParser(), {
      'label': {'type': 'text', 'data': 'Тег'},
      'onDeleted': {'actionType': 'none'},
    });
    expect(tester.widget<AppChip>(find.byType(AppChip)).onRemove, isNotNull);

    await pumpKit(tester, const StacDividerKitParser(), {'indent': 16});
    expect(find.byType(AppDivider), findsOneWidget);
    expect(find.byType(Divider), findsNothing);

    await pumpKit(tester, const StacCircleAvatarKitParser(), {
      'child': {'type': 'text', 'data': 'ИП'},
      'radius': 24,
    });
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).size, 48);

    await pumpKit(tester, const StacBadgeKitParser(), {
      'count': 3,
      'child': {'type': 'appLineIcon', 'icon': 'bell'},
    });
    expect(find.byType(AppCountBadge), findsOneWidget);
  });

  testWidgets('material form controls render kit controls', (tester) async {
    await pumpKit(tester, const StacTextFormFieldKitParser(), {
      'id': 'name',
      'decoration': {'hintText': 'Имя', 'labelText': 'Как звать'},
      'validatorRules': [
        {
          'rule': 'isLength',
          'options': {'min': 2},
          'message': 'Коротко',
        },
      ],
    });
    final field = tester.widget<AppInputField>(find.byType(AppInputField));
    expect(field.placeholder, 'Имя');
    expect(field.label, 'Как звать');
    expect(field.validator!('a'), 'Коротко');
    expect(field.validator!('ab'), isNull);

    await pumpKit(tester, const StacCheckBoxKitParser(), {'value': true});
    expect(tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value, isTrue);
    expect(find.byType(Checkbox), findsNothing);

    await pumpKit(tester, const StacSwitchKitParser(), {'value': false});
    expect(find.byType(AppSwitch), findsOneWidget);
    expect(find.byType(Switch), findsNothing);

    await pumpKit(tester, const StacRadioKitParser(), {
      'value': 'a',
      'groupValue': 'a',
    });
    expect(find.byType(AppRadio<Object?>), findsOneWidget);
  });

  testWidgets('material progress, image, app bar and dialog', (tester) async {
    await pumpKit(tester, const StacCircularProgressKitParser(), {});
    expect(find.byType(NinjaSpinner), findsOneWidget);

    await pumpKit(tester, const StacLinearProgressKitParser(), {'value': 0.5});
    final bar = tester.widget<NinjaProgressBar>(find.byType(NinjaProgressBar));
    expect(bar.value, 0.5);
    expect(bar.indeterminate, isFalse);

    await pumpKit(tester, const StacImageKitParser(), {'src': 'not a url'});
    expect(find.byType(ImagePlaceholder), findsOneWidget);

    await pumpKit(tester, const StacAppBarKitParser(), {
      'title': {'type': 'text', 'data': 'Шапка'},
    });
    expect(find.byType(KitAppBar), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);

    await pumpKit(tester, const StacAlertDialogKitParser(), {
      'title': {'type': 'text', 'data': 'Удалить?'},
      'content': {'type': 'text', 'data': 'Навсегда'},
      'actions': [
        {
          'type': 'textButton',
          'child': {'type': 'text', 'data': 'Нет'},
        },
        {
          'type': 'textButton',
          'child': {'type': 'text', 'data': 'Да'},
        },
      ],
    });
    final dialog = tester.widget<NinjaDialog>(find.byType(NinjaDialog));
    expect(dialog.confirmLabel, 'Да');
    expect(dialog.cancelLabel, 'Нет');
  });

  testWidgets('feedback actions open kit toast, dialog and sheet', (
    tester,
  ) async {
    var context = await _pumpHost(tester);
    const StacSnackBarKitActionParser().onCall(context, {
      'content': {'type': 'text', 'data': 'Сохранено'},
    });
    await tester.pumpAndSettle();
    expect(find.byType(AppToast), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    ToastManager.debugReset();

    context = await _pumpHost(tester);
    const StacConfirmActionParser().onCall(context, {
      'title': 'Удалить?',
      'isDanger': true,
      'confirmLabel': 'Удалить',
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(NinjaDialog), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.tap(find.text('Удалить'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(NinjaDialog), findsNothing);
  });

  testWidgets('bridge registration lets kit parsers win over built-ins', (
    tester,
  ) async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    );
    expect(StacBridge.widgetTypes, containsAll(['appButton', 'appTabs']));
    expect(StacBridge.actionTypes, contains('showSnackBar'));
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );
    final widget = Stac.fromJson({
      'type': 'elevatedButton',
      'child': {'type': 'text', 'data': 'Кит'},
    }, context);
    expect(widget, isA<AsyncActionBuilder>());
    expect(
      Stac.fromJson({'type': 'divider'}, context),
      isA<AppDivider>(),
    );
    final sheetJson = {
      'actionType': 'showModalBottomSheet',
      'widget': {'type': 'appText', 'data': 'Шторка'},
    };
    const StacModalBottomSheetKitActionParser().onCall(context, sheetJson);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(AppSheet), findsOneWidget);
    expect(find.text('Шторка'), findsOneWidget);
  });
}
