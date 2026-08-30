import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  late CustomHydratedStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    storage = CustomHydratedStorage(sharedPreferences: preferences);
  });

  test('writes and reads JSON-compatible values', () async {
    await storage.write('theme', {'colorScheme': 'green', 'isAmoled': true});

    expect(storage.read('theme'), {'colorScheme': 'green', 'isAmoled': true});
  });

  test('clear removes only hydrated values', () async {
    await preferences.setString('ui_preferences', 'preserve');
    await storage.write('theme', {'colorScheme': 'green'});

    await storage.clear();

    expect(preferences.getString('ui_preferences'), 'preserve');
    expect(storage.read('theme'), isNull);
  });
}
