import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/friends/widgets/friend_marker.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_marker_layer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Friend _friendAt({
  double? latitude,
  double? longitude,
  DateTime? locationUpdatedAt,
}) => Friend(
  friendshipId: 'f1',
  userId: 'u1',
  fullName: 'Наруто Узумаки',
  latitude: latitude,
  longitude: longitude,
  locationUpdatedAt: locationUpdatedAt,
);

Widget _wrap(Widget child, {bool disableAnimations = true}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: disableAnimations),
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

    test('returns null for coordinates outside geographic bounds', () {
      expect(friendPoint(_friendAt(latitude: 91, longitude: 0)), isNull);
      expect(friendPoint(_friendAt(latitude: 0, longitude: -181)), isNull);
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
      expect(find.byType(AppAvatar), findsOneWidget);

      final colors = tester.element(find.byType(FriendMarker)).colors;
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

    testWidgets('live markers do not run perpetual animations', (tester) async {
      await tester.pumpWidget(
        _wrap(
          FriendMarker(
            friend: _friendAt(
              latitude: 55.67,
              longitude: 37.48,
              locationUpdatedAt: DateTime.now(),
            ),
          ),
          disableAnimations: false,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.descendant(
          of: find.byType(FriendMarker),
          matching: find.byType(AnimatedBuilder),
        ),
        findsNothing,
      );
    });

    testWidgets('marker semantics include localized freshness', (tester) async {
      final friend = _friendAt(
        latitude: 55.67,
        longitude: 37.48,
        locationUpdatedAt: DateTime.now(),
      );
      await tester.pumpWidget(
        _wrap(
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(55.67, 37.48),
              initialZoom: 15,
            ),
            children: [
              FriendsMarkerLayer(
                friends: [friend],
                onFriendTap: (_) {},
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(
        find.bySemanticsLabel('Наруто Узумаки, сейчас'),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  });
}
