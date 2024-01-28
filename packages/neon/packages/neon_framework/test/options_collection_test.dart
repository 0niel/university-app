import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/settings.dart';
import 'package:neon_framework/src/settings/models/storage.dart';

// ignore: missing_override_of_must_be_overridden
class OptionMock extends Mock implements ToggleOption {}

class Collection extends AppImplementationOptions {
  Collection(List<Option<Object>> options) : super(const AppStorage(StorageKeys.apps)) {
    super.options = options;
  }
}

enum Keys implements Storable {
  key1._('key1'),
  key2._('key2');

  const Keys._(this.value);

  @override
  final String value;
}

void main() {
  group('OptionsCollection', () {
    final option1 = OptionMock();
    final option2 = OptionMock();
    final collection = Collection([
      option1,
      option2,
    ]);

    test('reset', () {
      collection.reset();

      verify(option1.reset).called(1);
      verify(option2.reset).called(1);
    });

    test('dispose', () {
      collection.dispose();

      verify(option1.dispose).called(1);
      verify(option2.dispose).called(1);
    });

    test('export', () {
      when(() => option1.key).thenReturn(Keys.key1);
      when(option1.serialize).thenReturn(true);
      when(() => option1.enabled).thenReturn(true);

      when(() => option2.key).thenReturn(Keys.key2);
      when(option2.serialize).thenReturn(true);
      when(() => option2.enabled).thenReturn(false);

      const json = {
        'app': {'key1': true},
      };

      final export = collection.export();

      expect(Map.fromEntries([export]), equals(json));
    });

    test('import', () {
      when(() => option1.key).thenReturn(Keys.key1);
      when(() => option2.key).thenReturn(Keys.key2);

      const json = {
        'app': {
          'key1': false,
          'key2': null,
        },
      };

      collection.import(json);

      verify(() => option1.load(false)).called(1);
      verify(option2.reset).called(1);
    });
  });
}
