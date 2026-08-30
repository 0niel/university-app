import 'dart:async';

import 'package:campus_repository/src/collab_note_presence_session.dart';
import 'package:supabase/supabase.dart';

final class SupabaseCollabNotePresenceSession
    implements CollabNotePresenceSession {
  factory SupabaseCollabNotePresenceSession({
    required RealtimeChannel channel,
    required String editorName,
  }) => SupabaseCollabNotePresenceSession._(channel, editorName);

  SupabaseCollabNotePresenceSession._(this._channel, this._editorName) {
    _subscribe();
  }

  final RealtimeChannel _channel;
  final String _editorName;
  final _editors = StreamController<List<String>>.broadcast();
  var _closed = false;

  @override
  Stream<List<String>> get editors => _editors.stream;

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
        .subscribe((status, error) {
          if (_closed) return;
          if (status == .subscribed) {
            unawaited(_track());
            return;
          }
          if (status == .channelError) {
            _editors.addError(
              error ?? StateError('Could not join note presence'),
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
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _channel.unsubscribe();
    await _editors.close();
  }
}
