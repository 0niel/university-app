import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/friends/widgets/friend_marker.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_marker_layer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Friend _friendAt({double? latitude, double? longitude}) => Friend(
  friendshipId: 'f1',
  userId: 'u1',
  fullName: 'Наруто Узумаки',
  latitude: latitude,
  longitude: longitude,
);

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

void main() {
  group('friendPoint', () {
    test('returns the point for finite coordinates', () {
      final point = friendPoint(_friendAt(latitude: 55.67, longitude: 37.48));
      expect(point, const LatLng(55.67, 37.48));
    });

    test('returns null when coordinates are missing', () {
      expect(friendPoint(_friendAt()), isNull);
      expect(friendPoint(_friendAt(latitude: 55.67)), isNull);
      expect(friendPoint(_friendAt(longitude: 37.48)), isNull);
    });

    test(
      'returns null for non-finite coordinates (flutter_map crash guard)',
      () {
        expect(
          friendPoint(_friendAt(latitude: double.nan, longitude: double.nan)),
          isNull,
        );
        expect(
          friendPoint(
            _friendAt(latitude: double.infinity, longitude: 37.48),
          ),
          isNull,
        );
        expect(
          friendPoint(
            _friendAt(latitude: 55.67, longitude: double.negativeInfinity),
          ),
          isNull,
        );
      },
    );
  });

  group('FriendMarker', () {
    testWidgets('draws a borderless surface bubble with a name pill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          FriendMarker(
            friend: _friendAt(latitude: 55.67, longitude: 37.48),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Наруто'), findsOneWidget);
      expect(find.byType(NinjaAvatar), findsOneWidget);

      final colors = tester.element(find.byType(FriendMarker)).ninja;
      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>();
      expect(decorations, isNotEmpty);
      expect(decorations.every((d) => d.border == null), isTrue);
      expect(decorations.every((d) => d.boxShadow == null), isTrue);
      expect(decorations.any((d) => d.color == colors.surface), isTrue);
    });

    testWidgets('my own marker keeps the single brand accent', (tester) async {
      await tester.pumpWidget(_wrap(const MyLocationMarker(isGhost: false)));
      await tester.pumpAndSettle();

      expect(find.text('Ты'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
