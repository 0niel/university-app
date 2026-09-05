import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:promo_repository/promo_repository.dart';

@immutable
class PromoDismissalsState {
  const PromoDismissalsState({
    this.snoozedUntil = const {},
    this.hidden = const {},
    this.pending = const {},
    this.isReady = true,
  });

  factory PromoDismissalsState.fromJson(Map<String, dynamic> json) {
    final snoozed = json['snoozedUntil'];
    final hidden = json['hidden'];
    final pending = json['pending'];
    return PromoDismissalsState(
      snoozedUntil: {
        if (snoozed is Map<dynamic, dynamic>)
          for (final entry in snoozed.entries)
            if (entry.key is String && entry.value is int)
              entry.key as String: entry.value as int,
      },
      hidden: {
        if (hidden is List<dynamic>) ...hidden.whereType<String>(),
      },
      pending: {
        if (pending is List<dynamic>) ...pending.whereType<String>(),
      },
    );
  }

  final Map<String, int> snoozedUntil;
  final Set<String> hidden;
  final Set<String> pending;
  final bool isReady;

  bool isVisible(PromoBanner banner, DateTime now) {
    if (!isReady) return false;
    final key = banner.dismissKey;
    if (hidden.contains(key)) return false;
    final until = snoozedUntil[key];
    return until == null || until <= now.millisecondsSinceEpoch;
  }

  PromoDismissalsState copyWith({
    Map<String, int>? snoozedUntil,
    Set<String>? hidden,
    Set<String>? pending,
    bool? isReady,
  }) => PromoDismissalsState(
    snoozedUntil: snoozedUntil ?? this.snoozedUntil,
    hidden: hidden ?? this.hidden,
    pending: pending ?? this.pending,
    isReady: isReady ?? this.isReady,
  );

  Map<String, dynamic> toJson() => {
    'snoozedUntil': snoozedUntil,
    'hidden': hidden.toList(),
    'pending': pending.toList(),
  };

  @override
  bool operator ==(Object other) =>
      other is PromoDismissalsState &&
      mapEquals(other.snoozedUntil, snoozedUntil) &&
      setEquals(other.hidden, hidden) &&
      setEquals(other.pending, pending) &&
      other.isReady == isReady;

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(snoozedUntil.entries.map((e) => (e.key, e.value))),
    Object.hashAllUnordered(hidden),
    Object.hashAllUnordered(pending),
    isReady,
  );
}

class PromoDismissalsCubit extends HydratedCubit<PromoDismissalsState>
    with WidgetsBindingObserver {
  PromoDismissalsCubit({
    this.userId = '',
    PromoRepository? repository,
    Duration refreshInterval = const Duration(minutes: 1),
  }) : _repository = repository,
       super(
         PromoDismissalsState(isReady: repository == null || userId.isEmpty),
       ) {
    if (_canSync) {
      WidgetsBinding.instance.addObserver(this);
      _timer = Timer.periodic(refreshInterval, (_) {
        final lifecycle = WidgetsBinding.instance.lifecycleState;
        if (lifecycle == null || lifecycle == AppLifecycleState.resumed) {
          unawaited(synchronize());
        }
      });
      unawaited(synchronize());
    }
  }

  final String userId;
  final PromoRepository? _repository;
  Timer? _timer;
  Future<void>? _synchronizing;

  bool get _canSync => userId.isNotEmpty && _repository != null;

  @override
  String get id => userId;

  @override
  String get storagePrefix => 'PromoDismissalsCubit';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(synchronize());
  }

  void snooze(PromoBanner banner, {DateTime? now}) {
    final until = (now ?? DateTime.now()).add(banner.snoozeDuration);
    emit(
      state.copyWith(
        snoozedUntil: {
          ...state.snoozedUntil,
          banner.dismissKey: until.millisecondsSinceEpoch,
        },
        pending: {...state.pending, if (_canSync) banner.dismissKey},
      ),
    );
    unawaited(synchronize());
  }

  void hide(PromoBanner banner) {
    emit(
      state.copyWith(
        hidden: {...state.hidden, banner.dismissKey},
        pending: {...state.pending, if (_canSync) banner.dismissKey},
      ),
    );
    unawaited(synchronize());
  }

  Future<void> synchronize() {
    if (!_canSync || isClosed) return Future<void>.value();
    return _synchronizing ??= _synchronize().whenComplete(() {
      _synchronizing = null;
    });
  }

  Future<void> _synchronize() async {
    try {
      final remote = await _repository!.getDismissals(userId: userId);
      if (isClosed) return;
      final hidden = {...state.hidden};
      final snoozedUntil = {...state.snoozedUntil};
      for (final dismissal in remote) {
        if (dismissal.hidden) hidden.add(dismissal.key);
        final until = dismissal.snoozedUntil?.millisecondsSinceEpoch;
        if (until != null && until > (snoozedUntil[dismissal.key] ?? 0)) {
          snoozedUntil[dismissal.key] = until;
        }
      }
      emit(
        state.copyWith(
          hidden: hidden,
          snoozedUntil: snoozedUntil,
          isReady: true,
        ),
      );
      while (state.pending.isNotEmpty && !isClosed) {
        final key = state.pending.first;
        final separator = key.lastIndexOf(':');
        final version = separator < 0
            ? null
            : int.tryParse(key.substring(separator + 1));
        if (version == null) {
          emit(state.copyWith(pending: {...state.pending}..remove(key)));
          continue;
        }
        final hidden = state.hidden.contains(key);
        final until = state.snoozedUntil[key];
        await _repository.saveDismissal(
          userId: userId,
          dismissal: PromoDismissal(
            bannerId: key.substring(0, separator),
            version: version,
            hidden: hidden,
            snoozedUntil: until == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(until, isUtc: true),
          ),
        );
        if (isClosed) return;
        if (state.hidden.contains(key) == hidden &&
            state.snoozedUntil[key] == until) {
          emit(state.copyWith(pending: {...state.pending}..remove(key)));
        }
      }
    } on Object {
      if (!isClosed) emit(state.copyWith(isReady: true));
    }
  }

  void reset() => emit(const PromoDismissalsState());

  @override
  Future<void> close() async {
    _timer?.cancel();
    if (_canSync) WidgetsBinding.instance.removeObserver(this);
    await super.close();
  }

  @override
  PromoDismissalsState? fromJson(Map<String, dynamic> json) =>
      PromoDismissalsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PromoDismissalsState state) => state.toJson();
}
