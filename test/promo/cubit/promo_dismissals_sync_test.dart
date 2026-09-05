import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/promo/cubit/promo_dismissals_cubit.dart';

class _Storage extends Mock implements Storage {}

class _Repository extends Fake implements PromoRepository {
  final records = <String, List<PromoDismissal>>{};
  final writes = <(String, PromoDismissal)>[];
  bool offline = false;
  Completer<List<PromoDismissal>>? readGate;
  Completer<void>? writeGate;

  @override
  Future<List<PromoDismissal>> getDismissals({required String userId}) async {
    if (offline) throw StateError('offline');
    return readGate?.future ?? records[userId] ?? [];
  }

  @override
  Future<void> saveDismissal({
    required String userId,
    required PromoDismissal dismissal,
  }) async {
    if (offline) throw StateError('offline');
    if (writeGate != null) await writeGate!.future;
    writes.add((userId, dismissal));
    records[userId] = [
      ...?records[userId]?.where((entry) => entry.key != dismissal.key),
      dismissal,
    ];
  }
}

const _banner = PromoBanner(
  id: 'b1',
  slug: 'promo',
  title: 'Promo',
  ctaUrl: 'https://example.com',
  version: 3,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Repository repository;
  late Map<String, dynamic> cache;
  final now = DateTime(2026, 9, 5);

  setUp(() {
    repository = _Repository();
    cache = {};
    final storage = _Storage();
    when(() => storage.read(any())).thenAnswer(
      (call) => cache[call.positionalArguments.first],
    );
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((call) async {
      cache[call.positionalArguments.first as String] =
          call.positionalArguments[1];
    });
    HydratedBloc.storage = storage;
  });

  PromoDismissalsCubit create([String userId = 'user-a']) {
    final cubit = PromoDismissalsCubit(userId: userId, repository: repository);
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    return cubit;
  }

  test(
    'restores a server hide only for the matching banner and version',
    () async {
      repository.records['user-a'] = [
        const PromoDismissal(bannerId: 'b1', version: 3, hidden: true),
      ];
      final cubit = create();
      expect(cubit.state.isReady, isFalse);
      await cubit.synchronize();
      expect(cubit.state.isVisible(_banner, now), isFalse);
      expect(cubit.state.isVisible(_banner.copyWith(id: 'b2'), now), isTrue);
      expect(cubit.state.isVisible(_banner.copyWith(version: 4), now), isTrue);
    },
  );

  test(
    'persists offline hides across restart and retries only their account',
    () async {
      repository.offline = true;
      final first = create();
      await first.synchronize();
      first.hide(_banner);
      await first.synchronize();
      expect(first.state.pending, {'b1:3'});
      await first.close();

      final other = create('user-b');
      await other.synchronize();
      expect(other.state.isVisible(_banner, now), isTrue);
      expect(other.state.pending, isEmpty);

      final restored = create();
      await restored.synchronize();
      expect(restored.state.isVisible(_banner, now), isFalse);
      repository.offline = false;
      await restored.synchronize();
      expect(restored.state.pending, isEmpty);
      expect(repository.writes.single.$1, 'user-a');
      expect(repository.writes.single.$2.hidden, isTrue);
    },
  );

  test('cloud snooze expires at the same instant on another device', () async {
    final first = create();
    await first.synchronize();
    first.snooze(_banner, now: now);
    await first.synchronize();
    final expiry = now.add(_banner.snoozeDuration);
    await first.close();
    cache.clear();
    final another = create();
    await another.synchronize();
    expect(another.state.isVisible(_banner, now), isFalse);
    expect(another.state.isVisible(_banner, expiry), isTrue);
  });

  test('a stale fetch cannot replace a dismissal made while loading', () async {
    repository.readGate = Completer<List<PromoDismissal>>();
    final cubit = create()..hide(_banner);
    repository.readGate!.complete([]);
    await cubit.synchronize();
    expect(cubit.state.isVisible(_banner, now), isFalse);
    expect(repository.writes.single.$2.hidden, isTrue);
  });

  test(
    'a newer hide is sent even when an earlier snooze is still writing',
    () async {
      final cubit = create();
      await cubit.synchronize();
      repository.writeGate = Completer<void>();
      cubit.snooze(_banner, now: now);
      await Future<void>.delayed(Duration.zero);
      cubit.hide(_banner);
      repository.writeGate!.complete();
      await cubit.synchronize();
      expect(repository.writes.length, 2);
      expect(repository.writes.last.$2.hidden, isTrue);
      expect(cubit.state.pending, isEmpty);
    },
  );

  test(
    'closing an old account discards its late fetch and pending writes',
    () async {
      repository.readGate = Completer<List<PromoDismissal>>();
      final cubit = create()..hide(_banner);
      final pending = cubit.synchronize();
      await cubit.close();
      repository.readGate!.complete([]);
      await pending;
      expect(repository.writes, isEmpty);
    },
  );

  test('anonymous users keep local state without account RPCs', () async {
    final cubit = create('')..hide(_banner);
    await cubit.synchronize();
    expect(cubit.state.isVisible(_banner, now), isFalse);
    expect(cubit.state.pending, isEmpty);
    expect(repository.writes, isEmpty);
  });
}
