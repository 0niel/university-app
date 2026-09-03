import 'dart:async';

import 'package:campus_repository/src/collab_note_realtime_session.dart';
import 'package:campus_repository/src/models/collab_note_change.dart';
import 'package:supabase/supabase.dart';

final class SupabaseCollabNoteRealtimeSession
    implements CollabNoteRealtimeSession {
  factory SupabaseCollabNoteRealtimeSession({
    required RealtimeChannel channel,
    required String editorName,
  }) => SupabaseCollabNoteRealtimeSession._(channel, editorName);

  SupabaseCollabNoteRealtimeSession._(this._channel, this._editorName) {
    _subscribe();
  }

  static const _changeEvent = 'document-committed-v2';

  final RealtimeChannel _channel;
  final String _editorName;
  final _editors = StreamController<List<String>>.broadcast();
  final _changes = StreamController<CollabNoteChange>.broadcast();
  final _connections = StreamController<void>.broadcast();
  var _closed = false;

  @override
  Stream<List<String>> get editors => _editors.stream;

  @override
  Stream<CollabNoteChange> get changes => _changes.stream;

  @override
  Stream<void> get connections => _connections.stream;

  void _subscribe() {
    _channel
        .onPresenceSync((_) {
          if (_closed) return;
          final names = <String>{
            for (final state in _channel.presenceState())
              for (final presence in state.presences)
                if (presence.payload['name'] case final String name)
                  if (name.trim().isNotEmpty) name.trim(),
          }.toList(growable: false)..sort();
          _editors.add(names);
        })
        .onBroadcast(
          event: _changeEvent,
          callback: (payload) {
            if (_closed) return;
            try {
              _changes.add(CollabNoteChange.fromPayload(payload));
            } on FormatException catch (error, stackTrace) {
              _changes.addError(error, stackTrace);
            }
          },
        )
        .subscribe((status, error) {
          if (_closed) return;
          if (status == .subscribed) {
            _connections.add(null);
            unawaited(_track());
            return;
          }
          if (status == .channelError) {
            _editors.addError(
              error ?? StateError('Could not join note channel'),
            );
          }
        });
  }

  Future<void> _track() async {
    try {
      await _channel.track({'name': _editorName});
    } on Exception catch (error, stackTrace) {
      if (!_closed) _editors.addError(error, stackTrace);
    }
  }

  @override
  Future<void> broadcastChange(CollabNoteChange change) async {
    if (_closed) return;
    await _channel.sendBroadcastMessage(
      event: _changeEvent,
      payload: change.toPayload(),
    );
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _channel.unsubscribe();
    await _editors.close();
    await _changes.close();
    await _connections.close();
  }
}
