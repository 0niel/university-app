import 'dart:async';

import 'package:campus_repository/src/models/collab_note_change.dart';
import 'package:campus_repository/src/supabase_collab_note_realtime_session.dart';
import 'package:test/test.dart';

import 'fakes/fake_realtime_channel.dart';

void main() {
  test('every subscription notifies resync and retracks presence', () async {
    final channel = FakeRealtimeChannel();
    final session = SupabaseCollabNoteRealtimeSession(
      channel: channel,
      editorName: 'Alex',
    );
    var connections = 0;
    final subscription = session.connections.listen((_) => connections++);
    channel.onStatus!(.subscribed, null);
    channel.onStatus!(.subscribed, null);
    await Future<void>.delayed(.zero);
    expect(connections, 2);
    expect(channel.tracks, 2);
    await subscription.cancel();
    await session.close();
    expect(channel.unsubscribed, isTrue);
  });

  test('broadcasts and receives only revisioned committed snapshots', () async {
    final channel = FakeRealtimeChannel();
    final session = SupabaseCollabNoteRealtimeSession(
      channel: channel,
      editorName: 'Alex',
    );
    const snapshot = CollabNoteChange(
      clientId: 'client',
      revision: 2,
      document: [
        {'insert': 'Saved\n'},
      ],
    );
    final received = <CollabNoteChange>[];
    final errors = <Object>[];
    final subscription = session.changes.listen(
      received.add,
      onError: errors.add,
    );
    await session.broadcastChange(snapshot);
    expect(channel.sentEvent, 'document-committed-v2');
    expect(channel.listenedEvent, channel.sentEvent);
    expect(channel.sentPayload, snapshot.toPayload());
    channel.onBroadcastPayload!(snapshot.toPayload());
    channel.onBroadcastPayload!({
      'clientId': 'old',
      'baseRevision': 0,
      'delta': <Object?>[],
    });
    await Future<void>.delayed(.zero);
    expect(received.singleOrNull!.revision, 2);
    expect(errors.singleOrNull, isA<FormatException>());
    await subscription.cancel();
    await session.close();
    channel.onBroadcastPayload!(snapshot.toPayload());
    channel.onStatus!(.subscribed, null);
    expect(channel.tracks, 0);
  });
}
