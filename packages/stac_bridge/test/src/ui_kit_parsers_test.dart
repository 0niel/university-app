import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/stac_toast_action_parser.dart';
import 'package:stac_bridge/src/widgets/kit/kit_widget_parsers.dart';

void main() {
  testWidgets('cards and typography resolve shared kit colors', (tester) async {
    const card = StacAppCardParser();
    const text = StacAppTextParser();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(
          builder: (context) => Column(
            children: [
              card.parse(context, card.getModel({'color': 'tint'})),
              text.parse(context, {'data': 'Native kit', 'variant': 'title'}),
            ],
          ),
        ),
      ),
    );
    final kitCard = tester.widget<AppCard>(find.byType(AppCard));
    final context = tester.element(find.byType(AppCard));
    expect(kitCard.color, context.colors.tint);
    expect(
      tester.widget<Text>(find.text('Native kit')).style!.fontFamily,
      AppText.sectionLarge.fontFamily,
    );
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('kit form input validates and writes Stac form values', (
    tester,
  ) async {
    const parser = StacAppInputFieldParser();
    final formKey = GlobalKey<FormState>();
    final values = <String, dynamic>{};
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: StacFormScope(
            formData: values,
            formKey: formKey,
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) => parser.parse(context, {
                  'id': 'email',
                  'label': 'Email',
                  'email': true,
                  'validationMessage': 'Invalid email',
                }),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(AppInputField), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Invalid email'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'student@example.test');
    expect(formKey.currentState!.validate(), isTrue);
    expect(values['email'], 'student@example.test');
    await tester.pump();
    expect(find.text('Invalid email'), findsNothing);
  });

  testWidgets('mini-app toast actions display the shared kit toast', (
    tester,
  ) async {
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
    const StacToastActionParser().onCall(context, {
      'message': 'Saved',
      'type': 'success',
    });
    await tester.pumpAndSettle();
    expect(find.byType(AppToast), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    ToastManager.debugReset();
  });

  testWidgets('legacy chip JSON renders a kit filter chip', (tester) async {
    const parser = StacAppChipParser();
    final model = parser.getModel({
      'label': 'Все',
      'small': true,
      'selected': true,
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => Scaffold(body: parser.parse(context, model)),
        ),
      ),
    );
    expect(find.text('Все'), findsOneWidget);
    final chip = tester.widget<AppChip>(find.byType(AppChip));
    expect(chip.selected, isTrue);
    expect(chip.style, AppChipStyle.filter);
    expect(tester.takeException(), isNull);
  });

  testWidgets('legacy icon JSON maps to kit tone and size', (tester) async {
    const parser = StacAppIconButtonParser();
    final model = parser.getModel({
      'icon': 'search',
      'variant': 'primary',
      'size': 'small',
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => Scaffold(body: parser.parse(context, model)),
        ),
      ),
    );
    final button = tester.widget<AppIconButton>(find.byType(AppIconButton));
    expect(button.tone, AppIconButtonTone.primary);
    expect(button.size, AppIconButtonSize.small);
    expect(tester.takeException(), isNull);
  });
}
