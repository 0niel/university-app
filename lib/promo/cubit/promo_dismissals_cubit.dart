import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:promo_repository/promo_repository.dart';

@immutable
class PromoDismissalsState {
  const PromoDismissalsState({
    this.snoozedUntil = const {},
    this.hidden = const {},
  });

  factory PromoDismissalsState.fromJson(Map<String, dynamic> json) {
    final snoozed = json['snoozedUntil'];
    final hidden = json['hidden'];
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
    );
  }

  final Map<String, int> snoozedUntil;
  final Set<String> hidden;

  bool isVisible(PromoBanner banner, DateTime now) {
    final key = banner.dismissKey;
    if (hidden.contains(key)) return false;
    final until = snoozedUntil[key];
    return until == null || until <= now.millisecondsSinceEpoch;
  }

  PromoDismissalsState copyWith({
    Map<String, int>? snoozedUntil,
    Set<String>? hidden,
  }) => PromoDismissalsState(
    snoozedUntil: snoozedUntil ?? this.snoozedUntil,
    hidden: hidden ?? this.hidden,
  );

  Map<String, dynamic> toJson() => {
    'snoozedUntil': snoozedUntil,
    'hidden': hidden.toList(),
  };

  @override
  bool operator ==(Object other) =>
      other is PromoDismissalsState &&
      mapEquals(other.snoozedUntil, snoozedUntil) &&
      setEquals(other.hidden, hidden);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(snoozedUntil.entries.map((e) => (e.key, e.value))),
    Object.hashAllUnordered(hidden),
  );
}

class PromoDismissalsCubit extends HydratedCubit<PromoDismissalsState> {
  PromoDismissalsCubit() : super(const PromoDismissalsState());

  void snooze(PromoBanner banner, {DateTime? now}) {
    final until = (now ?? DateTime.now()).add(banner.snoozeDuration);
    emit(
      state.copyWith(
        snoozedUntil: {
          ...state.snoozedUntil,
          banner.dismissKey: until.millisecondsSinceEpoch,
        },
      ),
    );
  }

  void hide(PromoBanner banner) {
    emit(state.copyWith(hidden: {...state.hidden, banner.dismissKey}));
  }

  void reset() => emit(const PromoDismissalsState());

  @override
  PromoDismissalsState? fromJson(Map<String, dynamic> json) =>
      PromoDismissalsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PromoDismissalsState state) => state.toJson();
}
