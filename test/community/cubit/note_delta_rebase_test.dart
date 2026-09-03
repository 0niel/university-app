import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_delta_rebase.dart';

void main() {
  group('rebaseLocalDeltaPatch', () {
    test('carries a remote-only change onto an unchanged local doc', () {
      final synced = Delta()..insert('hello\n');
      final local = Delta()..insert('hello\n');
      final server = Delta()..insert('hello world\n');

      final patch = rebaseLocalDeltaPatch(
        synced: synced,
        local: local,
        server: server,
      );

      expect(local.compose(patch), server);
    });

    test('keeps a local-only change when the server is unchanged', () {
      final synced = Delta()..insert('hello\n');
      final local = Delta()..insert('hello there\n');
      final server = Delta()..insert('hello\n');

      final patch = rebaseLocalDeltaPatch(
        synced: synced,
        local: local,
        server: server,
      );

      expect(local.compose(patch), local);
    });

    test('merges disjoint local and remote insertions', () {
      final synced = Delta()..insert('AB\n');
      final local = Delta()
        ..insert('A')
        ..insert('X')
        ..insert('B\n');
      final server = Delta()
        ..insert('A')
        ..insert('B')
        ..insert('Y')
        ..insert('\n');

      final patch = rebaseLocalDeltaPatch(
        synced: synced,
        local: local,
        server: server,
      );
      final rebased = local.compose(patch);
      final plainText = rebased.toList().map((op) => op.data).join();

      expect(plainText, contains('X'));
      expect(plainText, contains('Y'));
    });
  });
}
