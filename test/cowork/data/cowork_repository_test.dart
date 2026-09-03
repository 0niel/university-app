import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/cowork/data/cowork_repository.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const repository = LocalCoworkRepository();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('round trips and deletes the personal plan', () async {
    final booking = CoworkBooking(
      seatId: 'Т2',
      zone: CoworkZone.quiet,
      from: DateTime(2026, 9, 2, 12),
      until: DateTime(2026, 9, 2, 14),
    );
    expect(await repository.loadBooking(), isNull);
    await repository.saveBooking(booking);
    expect(await repository.loadBooking(), booking);
    await repository.saveBooking(null);
    expect(await repository.loadBooking(), isNull);
  });

  test(
    'malformed stored data reports an error instead of a phantom booking',
    () async {
      SharedPreferences.setMockInitialValues({
        LocalCoworkRepository.storageKey: '{"seatId":12}',
      });
      expect(repository.loadBooking(), throwsA(isA<Object>()));
    },
  );

  test('invalid identifiers never describe an active plan', () {
    final booking = CoworkBooking(
      seatId: 'Т999',
      zone: CoworkZone.quiet,
      from: DateTime(2026, 9, 2, 12),
      until: DateTime(2026, 9, 2, 14),
    );
    expect(booking.isActive(DateTime(2026, 9, 2, 13)), isFalse);
  });
}
