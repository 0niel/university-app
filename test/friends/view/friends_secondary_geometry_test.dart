import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_add_action.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_discovery.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_my_qr_sheet.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friend_card.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_discovery_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_header.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_results.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _app(Widget child, {bool dark = false, double scale = 1}) => MaterialApp(
  theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(scale), disableAnimations: true),
    child: child!,
  ),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'discovery empty state stretches and actions share height '
      'at $scale scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            FindFriendsDiscovery(
              state: const FindFriendsState(status: FindFriendsStatus.ready),
              onShowQr: () {},
              onScan: () {},
              onSendRequest: (_) {},
              onAddWholeGroup: () {},
              onInvite: () {},
              onRetry: () {},
            ),
            scale: scale,
          ),
        );
        await tester.pumpAndSettle();
        final actions = find.byType(NinjaFindFriendsDiscoveryAction);
        expect(
          tester.getSize(actions.first).height,
          tester.getSize(actions.last).height,
        );
        expect(tester.getSize(find.byType(AppEmptyState)).width, 350);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('empty search spans the content width at $scale scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          const NinjaFindFriendsResults(
            state: FindFriendsState(query: 'nobody'),
          ),
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(AppEmptyState)).width, 350);
      expect(tester.takeException(), isNull);
    });
  }

  for (final dark in [false, true]) {
    testWidgets('QR fits a 280px sheet content ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          Padding(
            padding: const EdgeInsets.all(20),
            child: FindFriendsMyQrSheet(userId: 'friend-id', onShare: () {}),
          ),
          dark: dark,
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final rect = tester.getRect(find.byType(QrImageView));
      expect(rect.width, 240);
      expect(rect.left, greaterThanOrEqualTo(20));
      expect(rect.right, lessThanOrEqualTo(300));
    });

    testWidgets(
      'request state fits compact large text ${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            NinjaFindFriendCard(
              name: 'Александра Константинопольская',
              subtitle: 'ИКБО-01-24 · @alexandra',
              trailing: FindFriendsAddAction(sent: true, onAdd: () {}),
            ),
            dark: dark,
            scale: 2,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          tester.getRect(find.byType(AppTag)).right,
          lessThanOrEqualTo(300),
        );
      },
    );
  }

  testWidgets(
    'discovery header shares the kit 20px inset and 44px close target',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          NinjaFindFriendsHeader(
            title: 'Добавить друзей',
            closeLabel: 'Закрыть',
            onClose: () {},
          ),
        ),
      );
      expect(tester.getTopLeft(find.text('Добавить друзей')).dx, 20);
      final size = tester.getSize(find.byType(AppHeaderCircleButton));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    },
  );
}
