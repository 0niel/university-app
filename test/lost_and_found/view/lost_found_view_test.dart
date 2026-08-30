import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_empty_state.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_item_skeleton.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_thumbnail.dart';

import '../../helpers/mocks/mock_lost_found_cubit.dart';

BoxDecoration _ctaDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(LostFoundReportCta),
          matching: find.byType(Container),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

int _pastelCardCount(WidgetTester tester, Color accentSoft) {
  var count = 0;
  for (final box in tester.widgetList<DecoratedBox>(
    find.byType(DecoratedBox),
  )) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color == accentSoft) {
      count++;
    }
  }
  return count;
}

void main() {
  late LostFoundCubit cubit;
  final item = LostFoundItem(
    id: 'item-1',
    authorId: 'user-1',
    itemName: 'Ключи',
    status: .found,
    createdAt: DateTime.utc(2026, 7, 11),
    category: 'keys',
    isMine: true,
  );

  setUp(() => cubit = MockLostFoundCubit());

  Widget buildSubject(LostFoundState state) {
    when(() => cubit.state).thenReturn(state);
    return MaterialApp(
      theme: NinjaTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: BlocProvider<LostFoundCubit>.value(
        value: cubit,
        child: const LostFoundView(),
      ),
    );
  }

  testWidgets('uses a skeleton instead of a spinner during cold load', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(const LostFoundState(status: .loading)),
    );
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LostFoundListSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 1);
  });

  testWidgets('keeps search available and routes catalogue filters', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(LostFoundState(status: .ready, items: [item])),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Divider), findsNothing);

    await tester.enterText(find.byType(TextField), 'ключ');
    verify(() => cubit.queryChanged('ключ')).called(1);

    await tester.tap(find.text('Потеряли · 0'));
    verify(() => cubit.tabChanged(LostFoundItemStatus.lost)).called(1);

    await tester.tap(
      find.descendant(
        of: find.byType(LostFoundCategoryPicker),
        matching: find.text('Ключи'),
      ),
    );
    verify(() => cubit.categoryChanged('keys')).called(1);
  });

  testWidgets('interactive filters and photo removal meet touch targets', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(LostFoundState(status: .ready, items: [item])),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final categoryButton = find.ancestor(
      of: find.descendant(
        of: find.byType(LostFoundCategoryPicker),
        matching: find.text('Ключи'),
      ),
      matching: find.byType(AppPressable),
    );
    expect(tester.getSize(categoryButton).height, greaterThanOrEqualTo(44));

    var removed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Scaffold(
          body: LostFoundPhotoThumbnail(
            image: LostFoundImageUpload(
              bytes: base64Decode(
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0l'
                'EQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
              ),
              contentType: 'image/png',
            ),
            onRemove: () => removed = true,
          ),
        ),
      ),
    );
    await tester.pump();

    final removeButton = find.byType(AppPressable);
    expect(tester.getSize(removeButton), const Size(44, 44));
    await tester.tap(removeButton);
    expect(removed, isTrue);
  });

  testWidgets('accessibility navigation disables catalogue transitions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(accessibleNavigation: true),
        child: buildSubject(LostFoundState(status: .ready, items: [item])),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(LostFoundCategoryPicker),
        matching: find.byType(NinjaChip),
      ),
      findsWidgets,
    );

    final tabTransitions = tester.widgetList<AnimatedContainer>(
      find.descendant(
        of: find.byType(NinjaSegmented<LostFoundItemStatus>),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(tabTransitions, isNotEmpty);
    expect(
      tabTransitions.every(
        (transition) => transition.duration == Duration.zero,
      ),
      isTrue,
    );

    await tester.tap(find.byType(LostFoundReportCta));
    await tester.pumpAndSettle();
    final reportTransition = tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: find.descendant(
              of: find.byType(LostFoundReportSheet),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is AppLineIconWidget &&
                    widget.icon == AppLineIcon.heart,
              ),
            ),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    expect(
      reportTransition.duration,
      Duration.zero,
    );
  });

  testWidgets('large-text skeleton matches the catalogue card extent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildSubject(const LostFoundState(status: .loading)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump();

    expect(
      tester.getSize(find.byType(LostFoundItemSkeleton).first).height,
      290,
    );
  });

  testWidgets("the report card is the screen's only pastel card", (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(LostFoundState(status: .ready, items: [item])),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final colors = tester.element(find.byType(LostFoundView)).ninja;
    final decoration = _ctaDecoration(tester);
    expect(decoration.color, colors.accentSoft);
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNull);
    expect(decoration.borderRadius, BorderRadius.circular(NinjaRadius.card));
    expect(_pastelCardCount(tester, colors.accentSoft), 1);
  });

  testWidgets('the pastel report card renders plain while loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(const LostFoundState(status: .loading)),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final colors = tester.element(find.byType(LostFoundView)).ninja;
    expect(_ctaDecoration(tester).color, colors.surface);
    expect(_pastelCardCount(tester, colors.accentSoft), 0);
  });

  testWidgets('the empty state offers a report action', (tester) async {
    await tester.pumpWidget(buildSubject(const LostFoundState(status: .ready)));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LostFoundEmptyState), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(LostFoundEmptyState),
        matching: find.text('Сообщить'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LostFoundReportSheet), findsOneWidget);
  });

  testWidgets('shows a retryable cold error instead of an empty state', (
    tester,
  ) async {
    when(() => cubit.load()).thenAnswer((_) async => true);
    await tester.pumpWidget(
      buildSubject(const LostFoundState(status: .failure)),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Не удалось загрузить объявления'), findsOneWidget);
    expect(find.text('Находок пока нет'), findsNothing);
    await tester.tap(find.text('Повторить'));
    verify(() => cubit.load()).called(1);
  });

  testWidgets('report form keeps contact sharing off until opted in', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(const LostFoundState(status: .ready)));

    await tester.tap(find.byType(LostFoundReportCta));
    await tester.pumpAndSettle();

    final consent = tester.widget<NinjaSwitch>(find.byType(NinjaSwitch));
    expect(consent.value, isFalse);
    expect(find.textContaining('моего университета'), findsWidgets);
  });

  testWidgets('confirms deletion before invoking the Cubit', (tester) async {
    when(() => cubit.deleteItem(item)).thenAnswer((_) async => true);
    await tester.pumpWidget(
      buildSubject(LostFoundState(status: .ready, items: [item])),
    );

    await tester.tap(
      find.descendant(
        of: find.byType(LostFoundItemCard),
        matching: find.text('Ключи'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить объявление'));
    await tester.pumpAndSettle();

    expect(find.text('Удалить объявление?'), findsOneWidget);
    verifyNever(() => cubit.deleteItem(item));
    await tester.tap(
      find.descendant(
        of: find.byType(NinjaDialog),
        matching: find.text('Удалить'),
      ),
    );
    await tester.pumpAndSettle();
    verify(() => cubit.deleteItem(item)).called(1);
  });

  testWidgets('does not expose an email fallback when contact is private', (
    tester,
  ) async {
    final privateItem = item.copyWith(isMine: false, authorName: 'Иван И.');
    await tester.pumpWidget(
      buildSubject(LostFoundState(status: .ready, items: [privateItem])),
    );

    await tester.tap(
      find.descendant(
        of: find.byType(LostFoundItemCard),
        matching: find.text('Ключи'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Автор не разрешил показывать контакты'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
  });

  testWidgets('supports 320px width at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildSubject(LostFoundState(status: .ready, items: [item])),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(LostFoundItemCard), findsOneWidget);
  });
}
