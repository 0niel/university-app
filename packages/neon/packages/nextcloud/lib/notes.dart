// coverage:ignore-file
import 'package:nextcloud/src/api/notes.openapi.dart';
import 'package:nextcloud/src/client.dart';

export 'src/api/notes.openapi.dart';
export 'src/helpers/notes.dart';

// ignore: public_member_api_docs
extension NotesExtension on NextcloudClient {
  static final _notes = Expando<$Client>();

  /// Client for the notes APIs
  $Client get notes => _notes[this] ??= $Client.fromClient(this);
}
