import 'dart:async';

import 'package:campus_repository/src/group_space_realtime_session.dart';
import 'package:supabase/supabase.dart';

final class SupabaseGroupSpaceRealtimeSession
    implements GroupSpaceRealtimeSession {
  factory SupabaseGroupSpaceRealtimeSession({
    required RealtimeChannel channel,
    required String groupId,
  }) => SupabaseGroupSpaceRealtimeSession._(channel, groupId);

  SupabaseGroupSpaceRealtimeSession._(this._channel, this._groupId) {
    _subscribe();
  }

  final RealtimeChannel _channel;
  final String _groupId;
  final _changes = StreamController<void>.broadcast();
  var _closed = false;

  @override
  Stream<void> get changes => _changes.stream;

  void _subscribe() {
    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'core',
          table: 'group_posts',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'group_id',
            value: _groupId,
          ),
          callback: (_) => _emit(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'core',
          table: 'group_post_likes',
          callback: (_) => _emit(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'core',
          table: 'group_post_comments',
          callback: (_) => _emit(),
        )
        .subscribe((status, error) {
          if (_closed) return;
          if (status == RealtimeSubscribeStatus.channelError) {
            _changes.addError(
              error ?? StateError('Could not join group space channel'),
            );
          }
        });
  }

  void _emit() {
    if (!_closed) _changes.add(null);
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _channel.unsubscribe();
    await _changes.close();
  }
}
