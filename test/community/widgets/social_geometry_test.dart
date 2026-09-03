import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/communities/widgets/community_join_button.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_skeleton.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_card.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list_skeleton.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('event RSVP keeps forty pixel paint and forty-four pixel input', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpApp(
      Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: EventCard(
            event: CampusEvent(
              id: 'event',
              title: 'Встреча клуба',
              startsAt: DateTime(2026, 9, 3),
            ),
            onToggleRsvp: () => calls++,
            onTap: () {},
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    final surface = find.byKey(const Key('eventCard_rsvpSurface'));
    final button = find.ancestor(
      of: surface,
      matching: find.byWidgetPredicate(
        (widget) => widget is AppPressState && widget.semanticsButton == true,
      ),
    );
    expect(tester.getSize(surface).height, 40);
    expect(tester.getSize(button).height, 44);
    await tester.tapAt(tester.getTopLeft(button) + const Offset(10, 1));
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'community save retains accessible target around forty-two pixel paint',
    (tester) async {
      var calls = 0;
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommunityJoinButton(
                  label: 'Сохранить',
                  joined: false,
                  onTap: () => calls++,
                ),
              ],
            ),
          ),
        ),
      );
      final surface = find.byKey(const Key('community_saveSurface'));
      final button = find.byType(CommunityJoinButton);
      expect(tester.getSize(surface).height, 42);
      expect(tester.getSize(button).height, 44);
      await tester.tapAt(tester.getTopLeft(button) + const Offset(10, .5));
      expect(calls, 1);
    },
  );

  for (final notes in [false, true]) {
    testWidgets(
      '${notes ? 'notes' : 'knowledge'} loading uses grouped rows '
      'and square icon tiles',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: notes
                ? const CollabNotesSkeleton()
                : const KnowledgeBankListSkeleton(),
          ),
          size: const Size(390, 844),
        );
        expect(find.byType(AppListGroup), findsOneWidget);
        final tiles = tester
            .widgetList<NinjaSkeleton>(find.byType(NinjaSkeleton))
            .where((tile) => tile.width == 44 && tile.height == 44);
        expect(tiles.length, notes ? 6 : 4);
        expect(tiles.every((tile) => tile.radius == AppRadius.tile), isTrue);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
