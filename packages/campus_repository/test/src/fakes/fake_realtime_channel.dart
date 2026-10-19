import 'package:supabase/supabase.dart';

class FakeRealtimeChannel implements RealtimeChannel {
  FakeRealtimeChannel({
    this.onStatus,
    this.onBroadcastPayload,
    this.listenedEvent,
    this.sentEvent,
    this.sentPayload,
  });

  void Function(RealtimeSubscribeStatus, Object?)? onStatus;
  void Function(Map<String, dynamic>)? onBroadcastPayload;
  String? listenedEvent;
  String? sentEvent;
  Map<String, dynamic>? sentPayload;
  int tracks = 0;
  bool unsubscribed = false;

  @override
  Never noSuchMethod(Invocation invocation) => throw UnsupportedError(
    'Unexpected realtime channel call: ${invocation.memberName}',
  );

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
