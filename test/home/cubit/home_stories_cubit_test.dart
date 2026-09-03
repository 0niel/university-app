import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/cubit/home_stories_cubit.dart';

void main() {
  test(
    'sources become seen only when opened in the current account scope',
    () async {
      final first = HomeStoriesCubit();
      expect(first.state, isEmpty);
      first
        ..markSeen('news')
        ..markSeen('news');
      expect(first.state, {'news'});
      final nextAccount = HomeStoriesCubit();
      expect(nextAccount.state, isEmpty);
      await first.close();
      await nextAccount.close();
    },
  );
}
