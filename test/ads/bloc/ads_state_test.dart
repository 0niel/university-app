import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/ads/bloc/ads_bloc.dart';

void main() {
  test(
    'restores the default when a legacy payload has no visibility field',
    () {
      expect(AdsState.fromJson({}), const AdsState());
    },
  );

  test('round-trips a persisted visibility preference', () {
    const state = AdsState(showAds: false);

    expect(state.toJson(), {'showAds': false});
  });
}
