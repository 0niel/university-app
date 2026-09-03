import 'dart:async';

import 'package:campus_repository/src/group_space_presence_session.dart';
import 'package:supabase/supabase.dart';

final class SupabaseGroupSpacePresenceSession
    implements GroupSpacePresenceSession {
  factory SupabaseGroupSpacePresenceSession({
    required RealtimeChannel channel,
  }) => SupabaseGroupSpacePresenceSession._(channel);

  SupabaseGroupSpacePresenceSession._(this._channel) {
    _subscribe();
  }

  final RealtimeChannel _channel;
  final _onlineCount = StreamController<int>.broadcast();
  var _closed = false;

  @override
  Stream<int> get onlineCount => _onlineCount.stream;

  void _subscribe() {
    _channel
        .onPresenceSync((_) {
          if (_closed) return;
          final keys = <String>{
            for (final state in _channel.presenceState())
              for (final presence in state.presences) presence.presenceRef,
          };
          _onlineCount.add(keys.length);
        })
        .subscribe((status, error) {
          if (_closed) return;
          if (status == RealtimeSubscribeStatus.subscribed) {
            unawaited(_track());
            return;
          }
          if (status == RealtimeSubscribeStatus.channelError) {
            _onlineCount.addError(
              error ?? StateError('Could not join group presence channel'),
            );
          }
        });
  }

  Future<void> _track() async {
    try {
      await _channel.track({
        'online_at': DateTime.now().toUtc().toIso8601String(),
      });
    } on Exception catch (error, stackTrace) {
      if (!_closed) _onlineCount.addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _channel.unsubscribe();
    await _onlineCount.close();
  }
}
