import 'dart:async';

import 'package:campus_repository/src/models/collab_note_change.dart';
import 'package:campus_repository/src/supabase_collab_note_realtime_session.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

class _Channel implements RealtimeChannel {
  void Function(RealtimeSubscribeStatus, Object?)? onStatus;
  void Function(Map<String, dynamic>)? onBroadcastPayload;
  String? listenedEvent;
  String? sentEvent;
  Map<String, dynamic>? sentPayload;
  int tracks = 0;
  bool unsubscribed = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  RealtimeChannel onPresenceSync(
    void Function(RealtimePresenceSyncPayload) callback,
  ) => this;

  @override
  RealtimeChannel onBroadcast({
    required String event,
    required void Function(Map<String, dynamic>) callback,
  }) {
    listenedEvent = event;
    onBroadcastPayload = callback;
    return this;
  }

  @override
  RealtimeChannel subscribe([
    void Function(RealtimeSubscribeStatus, Object?)? callback,
    Duration? timeout,
  ]) {
    onStatus = callback;
    return this;
  }

  @override
  Future<ChannelResponse> track(
    Map<String, dynamic> payload, [
    Map<String, dynamic> opts = const {},
  ]) async {
    tracks++;
    return ChannelResponse.ok;
  }

  @override
  Future<ChannelResponse> sendBroadcastMessage({
    required String event,
    required Map<String, dynamic> payload,
  }) async {
    sentEvent = event;
    sentPayload = payload;
    return ChannelResponse.ok;
  }

  @override
  Future<String> unsubscribe([Duration? timeout]) async {
    unsubscribed = true;
    return 'ok';
  }
}

void main() {
  test('every subscription notifies resync and retracks presence', () async {
    final channel = _Channel();
    final session = SupabaseCollabNoteRealtimeSession(
      channel: channel,
      editorName: 'Alex',
    );
    var connections = 0;
    final subscription = session.connections.listen((_) => connections++);
    channel.onStatus!(RealtimeSubscribeStatus.subscribed, null);
    channel.onStatus!(RealtimeSubscribeStatus.subscribed, null);
    await Future<void>.delayed(Duration.zero);
    expect(connections, 2);
    expect(channel.tracks, 2);
    await subscription.cancel();
    await session.close();
    expect(channel.unsubscribed, isTrue);
  });

  test('broadcasts and receives only revisioned committed snapshots', () async {
    final channel = _Channel();
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
    await Future<void>.delayed(Duration.zero);
    expect(received.single.revision, 2);
    expect(errors.single, isA<FormatException>());
    await subscription.cancel();
    await session.close();
    channel.onBroadcastPayload!(snapshot.toPayload());
    channel.onStatus!(RealtimeSubscribeStatus.subscribed, null);
    expect(channel.tracks, 0);
  });
}
