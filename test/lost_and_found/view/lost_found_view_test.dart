import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_thumbnail.dart';

import '../../helpers/mocks/mock_lost_found_cubit.dart';
import '../../helpers/pump_app.dart';

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

  Widget subject(LostFoundState state) {
    when(() => cubit.state).thenReturn(state);
    return BlocProvider<LostFoundCubit>.value(
      value: cubit,
      child: const LostFoundView(),
    );
  }

  Future<void> openReport(WidgetTester tester) async {
    final header = tester.widget<AppInnerHeader>(find.byType(AppInnerHeader));
    header.actions.first.onTap!();
    await tester.pumpAndSettle();
  }

  testWidgets('cold loading uses the row skeleton scene', (tester) async {
    await tester.pumpApp(subject(const LostFoundState(status: .loading)));
    expect(find.byType(LostFoundSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
  });

  testWidgets('segmented filters hide nonmatching real items', (tester) async {
    await tester.pumpApp(
      subject(LostFoundState(status: .ready, items: [item])),
    );
    expect(find.byType(LostFoundRow), findsOneWidget);
    await tester.tap(find.text('Ищут'));
    await tester.pumpAndSettle();
    expect(find.byType(LostFoundRow), findsNothing);
    await tester.tap(find.text('Все'));
    await tester.pumpAndSettle();
    expect(find.byType(LostFoundRow), findsOneWidget);
  });

  testWidgets('photo removal keeps its 44px target and callback', (
    tester,
  ) async {
    var removed = false;
    await tester.pumpApp(
      Scaffold(
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
    );
    final button = find.byType(AppPressable);
    expect(tester.getSize(button), const Size(44, 44));
    await tester.tap(button);
    expect(removed, isTrue);
  });

  testWidgets('accessible navigation keeps tabs and report action usable', (
    tester,
  ) async {
    await tester.pumpApp(
      MediaQuery(
        data: const MediaQueryData(accessibleNavigation: true),
        child: subject(LostFoundState(status: .ready, items: [item])),
      ),
    );
    await tester.tap(find.text('Нашли').first);
    await tester.pumpAndSettle();
    expect(find.byType(LostFoundRow), findsOneWidget);
    await openReport(tester);
    expect(find.byType(LostFoundReportSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading skeleton fits 320px with large text', (tester) async {
    await tester.pumpApp(
      subject(const LostFoundState(status: .loading)),
      size: const Size(320, 760),
      textScaler: const TextScaler.linear(2),
    );
    expect(find.byType(LostFoundSkeleton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('security help is present with populated listings', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(LostFoundState(status: .ready, items: [item])),
    );
    expect(find.byType(LostFoundSecurityCard), findsOneWidget);
    expect(find.byType(AppInnerHeader), findsOneWidget);
  });

  testWidgets('security help remains visible while loading', (tester) async {
    await tester.pumpApp(subject(const LostFoundState(status: .loading)));
    expect(find.byType(LostFoundSecurityCard), findsOneWidget);
    expect(find.byType(LostFoundSkeleton), findsOneWidget);
  });

  testWidgets('empty catalogue still offers a real report action', (
    tester,
  ) async {
    await tester.pumpApp(subject(const LostFoundState(status: .ready)));
    expect(find.byType(NinjaEmptyState), findsOneWidget);
    await openReport(tester);
    expect(find.byType(LostFoundReportSheet), findsOneWidget);
  });

  testWidgets('cold failure offers retry instead of false empty state', (
    tester,
  ) async {
    when(() => cubit.load()).thenAnswer((_) async => true);
    await tester.pumpApp(subject(const LostFoundState(status: .failure)));
    expect(find.text('Не удалось загрузить объявления'), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    verify(() => cubit.load()).called(1);
  });

  testWidgets('report sharing starts disabled until explicit consent', (
    tester,
  ) async {
    await tester.pumpApp(subject(const LostFoundState(status: .ready)));
    await openReport(tester);
    expect(tester.widget<NinjaSwitch>(find.byType(NinjaSwitch)).value, isFalse);
    expect(find.textContaining('моего университета'), findsWidgets);
  });

  testWidgets('deletion requires confirmation before the cubit mutation', (
    tester,
  ) async {
    when(() => cubit.deleteItem(item)).thenAnswer((_) async => true);
    await tester.pumpApp(
      subject(LostFoundState(status: .ready, items: [item])),
    );
    await tester.tap(find.text('Ключи'));
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

  testWidgets('private contacts never fall back to an email address', (
    tester,
  ) async {
    await tester.pumpApp(
      subject(
        LostFoundState(
          status: .ready,
          items: [item.copyWith(isMine: false, authorName: 'Иван И.')],
        ),
      ),
    );
    await tester.tap(find.text('Ключи'));
    await tester.pumpAndSettle();
    expect(find.text('Автор не разрешил показывать контакты'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
  });

  testWidgets('ready rows fit 320px at 200 percent text', (tester) async {
    await tester.pumpApp(
      subject(LostFoundState(status: .ready, items: [item])),
      size: const Size(320, 760),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(LostFoundRow), findsOneWidget);
  });
}
