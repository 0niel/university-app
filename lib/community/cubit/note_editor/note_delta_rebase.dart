import 'package:flutter_quill/quill_delta.dart';

Delta rebaseLocalDeltaPatch({
  required Delta synced,
  required Delta local,
  required Delta server,
}) {
  final serverDiff = synced.diff(server);
  final localDiff = synced.diff(local);
  final transformedLocal = serverDiff.transform(localDiff, true);
  final rebasedDoc = server.compose(transformedLocal);
  return local.diff(rebasedDoc);
}
