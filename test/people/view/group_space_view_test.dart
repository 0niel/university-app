import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_cubit.dart';
import 'package:rtu_mirea_app/people/cubit/group_space/group_space_status.dart';
import 'package:rtu_mirea_app/people/utils/external_link_launcher.dart';
import 'package:rtu_mirea_app/people/view/group_space_view.dart';
import 'package:rtu_mirea_app/people/widgets/group_space/group_space_widgets.dart';

import '../../helpers/pump_app.dart';

class _MockGroupSpaceCubit extends Mock implements GroupSpaceCubit {}

class _MockExternalLinkLauncher extends Mock implements ExternalLinkLauncher {}

void main() {
  late GroupSpaceCubit cubit;
  late ExternalLinkLauncher launcher;

  setUpAll(() => registerFallbackValue(Uri()));

  setUp(() {
    cubit = _MockGroupSpaceCubit();
    launcher = _MockExternalLinkLauncher();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(cubit.clearMutationFailure).thenReturn(null);
    when(cubit.load).thenAnswer((_) async {});
  });

  Widget buildSubject(GroupSpaceState state, {String? initialPostId}) {
    when(() => cubit.state).thenReturn(state);
    return RepositoryProvider<ExternalLinkLauncher>.value(
      value: launcher,
      child: BlocProvider<GroupSpaceCubit>.value(
        value: cubit,
        child: GroupSpaceView(initialPostId: initialPostId),
      ),
    );
  }

  testWidgets('shows a truthful cold error and retries', (tester) async {
    await tester.pumpApp(
      buildSubject(const GroupSpaceState(status: GroupSpaceStatus.failure)),
    );

    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byType(NinjaEmptyState), findsNothing);
    await tester.tap(find.text('Повторить'));

    verify(cubit.load).called(1);
  });

  testWidgets('shows no-group state only after a successful load', (
    tester,
  ) async {
    await tester.pumpApp(
      buildSubject(const GroupSpaceState(status: GroupSpaceStatus.success)),
    );

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.byType(NinjaErrorState), findsNothing);
    expect(
      find.descendant(
        of: find.byType(NinjaEmptyState),
        matching: find.text('Люди'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('keeps stale content visible while refreshing', (tester) async {
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      isRefreshing: true,
      space: GroupSpace(group: 'ИКБО-01', hasGroup: true),
    );
    await tester.pumpApp(buildSubject(state));

    expect(find.text('ИКБО-01'), findsWidgets);
    expect(find.byType(NinjaErrorState), findsNothing);
  });

  testWidgets(
    'group owner can swipe to delete a link created by another member',
    (tester) async {
      const link = GroupLink(
        id: 'link-1',
        title: 'Drive',
        url: 'https://example.com',
      );
      const state = GroupSpaceState(
        status: GroupSpaceStatus.success,
        space: GroupSpace(
          group: 'ИКБО-01',
          hasGroup: true,
          isOwner: true,
          links: [link],
        ),
      );
      when(() => cubit.deleteLink('link-1')).thenAnswer((_) async => true);
      await tester.pumpApp(buildSubject(state));

      // The always-visible trash icon was replaced by swipe-to-delete.
      expect(find.byTooltip('Удалить'), findsNothing);
      expect(find.byType(Dismissible), findsOneWidget);

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      final confirmButton = find.widgetWithText(NinjaPillButton, 'Удалить');
      expect(confirmButton, findsOneWidget);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      verify(() => cubit.deleteLink('link-1')).called(1);
    },
  );

  testWidgets('disables a link swipe-delete while its mutation is pending', (
    tester,
  ) async {
    const link = GroupLink(
      id: 'link-1',
      title: 'Drive',
      url: 'https://example.com',
    );
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(
        group: 'ИКБО-01',
        hasGroup: true,
        isOwner: true,
        links: [link],
      ),
      pendingLinkDeleteIds: {'link-1'},
    );
    await tester.pumpApp(buildSubject(state));

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    verifyNever(() => cubit.deleteLink(any()));
    // AppPressable also renders AnimatedOpacity widgets, so match the
    // pending-dim value across all of them instead of expecting exactly one.
    expect(
      tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((widget) => widget.opacity),
      contains(0.5),
    );
  });

  testWidgets('non-owner cannot add the missing Telegram link', (tester) async {
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(group: 'ИКБО-01', hasGroup: true),
    );
    await tester.pumpApp(buildSubject(state));

    expect(find.byType(NinjaGroupAddTelegramCard), findsNothing);
  });

  testWidgets('disables a note like while its mutation is pending', (
    tester,
  ) async {
    const note = GroupNote(
      id: 'note-1',
      title: 'Конспект',
      authorName: 'Анна',
      likes: 3,
    );
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(group: 'ИКБО-01', hasGroup: true, notes: [note]),
      pendingLikeIds: {'note-1'},
    );
    await tester.pumpApp(buildSubject(state));
    await tester.scrollUntilVisible(find.byType(NinjaGroupNoteCard), 200);

    final like = tester.widget<AppPressable>(
      find.ancestor(
        of: find.text('3'),
        matching: find.byType(AppPressable),
      ),
    );
    expect(like.onTap, isNull);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((widget) => widget.opacity),
      contains(0.45),
    );
    verifyNever(() => cubit.toggleLike(any()));
  });

  testWidgets('opens the post selected in global search', (tester) async {
    const note = GroupNote(
      id: 'note-1',
      title: 'Конспект по ML',
      authorName: 'Анна',
      body: 'Материалы и примеры к семинару',
    );
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(
        group: 'ИКБО-01',
        hasGroup: true,
        notes: [note],
      ),
    );
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));

    await tester.pumpApp(
      buildSubject(state, initialPostId: 'note-1'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Материалы и примеры к семинару'), findsOneWidget);
    expect(find.text('Анна'), findsOneWidget);
  });

  testWidgets('fits a 320 px viewport at 200 percent text scale', (
    tester,
  ) async {
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(
        group: 'Очень длинное название учебной группы',
        hasGroup: true,
        memberCount: 32,
        memberNames: ['Анна', 'Иван', 'Мария'],
      ),
    );
    await tester.pumpApp(
      buildSubject(state),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects an unsafe stored link without calling launcher', (
    tester,
  ) async {
    const link = GroupLink(
      id: 'link-1',
      title: 'Unsafe',
      url: 'javascript:alert(1)',
    );
    const state = GroupSpaceState(
      status: GroupSpaceStatus.success,
      space: GroupSpace(group: 'ИКБО-01', hasGroup: true, links: [link]),
    );
    await tester.pumpApp(buildSubject(state));

    await tester.tap(find.text('Unsafe'));
    await tester.pump();

    verifyNever(() => launcher.open(any()));
    expect(find.text('Ошибка'), findsWidgets);
    await tester.pump(const Duration(seconds: 4));
  });

  for (final throws in [false, true]) {
    testWidgets(
      throws
          ? 'shows a visible error when launcher throws'
          : 'shows a visible error when launcher returns false',
      (tester) async {
        const link = GroupLink(
          id: 'link-1',
          title: 'Safe',
          url: 'https://example.com/path',
        );
        const state = GroupSpaceState(
          status: GroupSpaceStatus.success,
          space: GroupSpace(group: 'ИКБО-01', hasGroup: true, links: [link]),
        );
        if (throws) {
          when(() => launcher.open(any())).thenThrow(Exception('platform'));
        } else {
          when(() => launcher.open(any())).thenAnswer((_) async => false);
        }
        await tester.pumpApp(buildSubject(state));

        await tester.tap(find.text('Safe'));
        await tester.pump();

        verify(
          () => launcher.open(Uri.parse('https://example.com/path')),
        ).called(1);
        expect(find.text('Ошибка'), findsWidgets);
        await tester.pump(const Duration(seconds: 4));
      },
    );
  }
}
