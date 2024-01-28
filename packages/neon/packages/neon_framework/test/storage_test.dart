import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

void main() {
  test('NeonStorage', () async {
    expect(() => NeonStorage.database, throwsA(isA<StateError>()));

    SharedPreferences.setMockInitialValues({});
    await NeonStorage.init();

    expect(NeonStorage.database, isA<SharedPreferences>());
  });

  group('AppStorage', () {
    test('formatKey', () async {
      var appStorage = const AppStorage(StorageKeys.accounts);
      var key = appStorage.formatKey('test-key');
      expect(key, 'accounts-test-key');
      expect(appStorage.id, StorageKeys.accounts.value);

      appStorage = const AppStorage(StorageKeys.accounts, 'test-suffix');
      key = appStorage.formatKey('test-key');
      expect(key, 'accounts-test-suffix-test-key');
      expect(appStorage.id, 'test-suffix');
    });

    test('interface', () async {
      final sharedPreferences = SharedPreferencesMock();
      NeonStorage.mock(sharedPreferences);
      const appStorage = AppStorage(StorageKeys.accounts);
      const key = 'key';
      final formattedKey = appStorage.formatKey(key);

      when(() => sharedPreferences.containsKey(formattedKey)).thenReturn(true);
      dynamic result = appStorage.containsKey(key);
      expect(result, equals(true));
      verify(() => sharedPreferences.containsKey(formattedKey)).called(1);

      when(() => sharedPreferences.remove(formattedKey)).thenAnswer((_) => Future.value(false));
      result = await appStorage.remove(key);
      expect(result, equals(false));
      verify(() => sharedPreferences.remove(formattedKey)).called(1);

      when(() => sharedPreferences.getString(formattedKey)).thenReturn(null);
      result = appStorage.getString(key);
      expect(result, isNull);
      verify(() => sharedPreferences.getString(formattedKey)).called(1);

      when(() => sharedPreferences.setString(formattedKey, 'value')).thenAnswer((_) => Future.value(false));
      result = await appStorage.setString(key, 'value');
      expect(result, false);
      verify(() => sharedPreferences.setString(formattedKey, 'value')).called(1);

      when(() => sharedPreferences.getBool(formattedKey)).thenReturn(true);
      result = appStorage.getBool(key);
      expect(result, equals(true));
      verify(() => sharedPreferences.getBool(formattedKey)).called(1);

      when(() => sharedPreferences.setBool(formattedKey, true)).thenAnswer((_) => Future.value(true));
      result = await appStorage.setBool(key, true);
      expect(result, true);
      verify(() => sharedPreferences.setBool(formattedKey, true)).called(1);

      when(() => sharedPreferences.getStringList(formattedKey)).thenReturn(['hi there']);
      result = appStorage.getStringList(key);
      expect(result, equals(['hi there']));
      verify(() => sharedPreferences.getStringList(formattedKey)).called(1);

      when(() => sharedPreferences.setStringList(formattedKey, ['hi there'])).thenAnswer((_) => Future.value(false));
      result = await appStorage.setStringList(key, ['hi there']);
      expect(result, false);
      verify(() => sharedPreferences.setStringList(formattedKey, ['hi there'])).called(1);
    });
  });

  test('SingleValueStorage', () async {
    final sharedPreferences = SharedPreferencesMock();
    NeonStorage.mock(sharedPreferences);
    const storage = SingleValueStorage(StorageKeys.global);
    final key = StorageKeys.global.value;

    when(() => sharedPreferences.containsKey(key)).thenReturn(true);
    dynamic result = storage.hasValue();
    expect(result, equals(true));
    verify(() => sharedPreferences.containsKey(key)).called(1);

    when(() => sharedPreferences.remove(key)).thenAnswer((_) => Future.value(false));
    result = await storage.remove();
    expect(result, equals(false));
    verify(() => sharedPreferences.remove(key)).called(1);

    when(() => sharedPreferences.getString(key)).thenReturn(null);
    result = storage.getString();
    expect(result, isNull);
    verify(() => sharedPreferences.getString(key)).called(1);

    when(() => sharedPreferences.setString(key, 'value')).thenAnswer((_) => Future.value(false));
    result = await storage.setString('value');
    expect(result, false);
    verify(() => sharedPreferences.setString(key, 'value')).called(1);

    when(() => sharedPreferences.getBool(key)).thenReturn(true);
    result = storage.getBool();
    expect(result, equals(true));
    verify(() => sharedPreferences.getBool(key)).called(1);

    when(() => sharedPreferences.setBool(key, true)).thenAnswer((_) => Future.value(true));
    result = await storage.setBool(true);
    expect(result, true);
    verify(() => sharedPreferences.setBool(key, true)).called(1);

    when(() => sharedPreferences.getStringList(key)).thenReturn(['hi there']);
    result = storage.getStringList();
    expect(result, equals(['hi there']));
    verify(() => sharedPreferences.getStringList(key)).called(1);

    when(() => sharedPreferences.setStringList(key, ['hi there'])).thenAnswer((_) => Future.value(false));
    result = await storage.setStringList(['hi there']);
    expect(result, false);
    verify(() => sharedPreferences.setStringList(key, ['hi there'])).called(1);
  });
}
