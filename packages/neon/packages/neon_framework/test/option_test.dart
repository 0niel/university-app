// ignore_for_file: discarded_futures

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/src/settings/models/option.dart';
import 'package:neon_framework/src/settings/models/storage.dart';

class MockStorage extends Mock implements SettingsStorage {}

class MockCallbackFunction extends Mock {
  FutureOr<void> call();
}

enum StorageKey implements Storable {
  key._('storage-key');

  const StorageKey._(this.value);

  @override
  final String value;
}

enum SelectValues {
  first,
  second,
  third,
}

void main() {
  final storage = MockStorage();
  const key = StorageKey.key;
  String labelBuilder(_) => 'label';

  group('SelectOption', () {
    final valuesLabel = {
      SelectValues.first: (_) => 'first',
      SelectValues.second: (_) => 'second',
      SelectValues.third: (_) => 'third',
    };

    late SelectOption<SelectValues> option;

    setUp(() {
      when(() => storage.setString(key.value, any())).thenAnswer((_) async => true);
      when(() => storage.remove(key.value)).thenAnswer((_) async => true);

      option = SelectOption<SelectValues>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
      );
    });

    tearDown(() {
      reset(storage);
      option.dispose();
    });

    test('Create', () {
      expect(option.value, option.defaultValue, reason: 'Should default to defaultValue.');

      when(() => storage.getString(key.value)).thenReturn('SelectValues.second');

      option = SelectOption<SelectValues>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
      );

      expect(option.value, SelectValues.second, reason: 'Should load value from storage when available.');
    });

    test('Depend', () {
      final enabled = ValueNotifier(false);
      final callback = MockCallbackFunction();

      option = SelectOption<SelectValues>.depend(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: SelectValues.first,
        values: valuesLabel,
        enabled: enabled,
      )..addListener(callback.call);

      expect(option.enabled, enabled.value, reason: 'Should initialize with enabled value.');

      enabled.value = true;
      verify(callback.call).called(1);
      expect(option.enabled, enabled.value, reason: 'Should update the enabled state.');
    });

    test('Update', () {
      final callback = MockCallbackFunction();
      option
        ..addListener(callback.call)
        ..value = SelectValues.third;

      verify(callback.call).called(1);
      verify(() => storage.setString(key.value, 'SelectValues.third')).called(1);
      expect(option.value, SelectValues.third, reason: 'Should update the value.');

      option.value = SelectValues.third;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.value, SelectValues.third, reason: 'Should keep the value.');
    });

    test('Disable', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.enabled, true, reason: 'Should default to enabled');

      option.enabled = false;
      verify(callback.call).called(1);
      expect(option.enabled, false, reason: 'Should disable option.');

      option.enabled = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.enabled, false, reason: 'Should keep the value.');
    });

    test('Change values', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.values, equals(valuesLabel));

      final newValues = {
        SelectValues.second: (_) => 'second',
        SelectValues.third: (_) => 'third',
      };

      option.values = newValues;
      verify(callback.call).called(1);
      expect(option.values, equals(newValues), reason: 'Should change values.');

      option.values = newValues;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.values, newValues, reason: 'Should keep the values.');
    });

    test('Invalid values', () {
      expect(option.values, equals(valuesLabel));

      option
        ..value = SelectValues.second
        ..values = {
          SelectValues.first: (_) => 'first',
          SelectValues.third: (_) => 'third',
        };
      expect(option.value, SelectValues.first, reason: 'Invalid value.');

      option.value = SelectValues.second;
      expect(option.value, SelectValues.first, reason: 'Invalid value.');
    });

    test('Reset', () {
      final callback = MockCallbackFunction();
      option
        ..value = SelectValues.third
        ..addListener(callback.call);

      expect(option.value, SelectValues.third);

      option.reset();

      verify(callback.call).called(1);
      verify(() => storage.remove(key.value)).called(1);
      expect(option.value, option.defaultValue, reason: 'Should reset the value.');
    });

    test('Serialize null', () {
      final option = SelectOption<SelectValues?>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: null,
        values: valuesLabel,
      );

      expect(option.serialize(), null, reason: 'Should serialize to null. A string containing "null" is an error');
    });

    test('Deserialize', () {
      final option = SelectOption<SelectValues?>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: null,
        values: valuesLabel,
      );

      // ignore: cascade_invocations
      option.load('SelectValues.second');

      expect(option.value, SelectValues.second);
    });

    test('Stream', () async {
      final option = SelectOption<SelectValues?>(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: null,
        values: valuesLabel,
      );

      expect(await option.stream.first, option.defaultValue);
      option.value = SelectValues.second;
      expect(await option.stream.first, SelectValues.second);
    });
  });

  group('ToggleOption', () {
    late ToggleOption option;

    setUp(() {
      when(() => storage.setBool(key.value, any())).thenAnswer((_) async => true);
      when(() => storage.remove(key.value)).thenAnswer((_) async => true);

      option = ToggleOption(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: true,
      );
    });

    tearDown(() {
      reset(storage);
      option.dispose();
    });

    test('Create', () {
      expect(option.value, option.defaultValue, reason: 'Should default to defaultValue.');

      when(() => storage.getBool(key.value)).thenReturn(true);

      option = ToggleOption(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: false,
      );

      expect(option.value, true, reason: 'Should load value from storage when available.');
    });

    test('Depend', () {
      final enabled = ValueNotifier(false);
      final callback = MockCallbackFunction();

      option = ToggleOption.depend(
        storage: storage,
        key: key,
        label: labelBuilder,
        defaultValue: true,
        enabled: enabled,
      )..addListener(callback.call);

      expect(option.enabled, enabled.value, reason: 'Should initialize with enabled value.');

      enabled.value = true;
      verify(callback.call).called(1);
      expect(option.enabled, enabled.value, reason: 'Should update the enabled state.');
    });

    test('Update', () {
      final callback = MockCallbackFunction();
      option
        ..addListener(callback.call)
        ..value = false;

      verify(callback.call).called(1);
      verify(() => storage.setBool(key.value, false)).called(1);
      expect(option.value, false, reason: 'Should update the value.');

      option.value = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.value, false, reason: 'Should keep the value.');
    });

    test('Disable', () {
      final callback = MockCallbackFunction();
      option.addListener(callback.call);

      expect(option.enabled, true, reason: 'Should default to enabled');

      option.enabled = false;
      verify(callback.call).called(1);
      expect(option.enabled, false, reason: 'Should disable option.');

      option.enabled = false;
      verifyNever(callback.call); // Don't notify with the same value
      expect(option.enabled, false, reason: 'Should keep the value.');
    });

    test('Reset', () {
      final callback = MockCallbackFunction();
      option
        ..value = false
        ..addListener(callback.call);

      expect(option.value, false);

      option.reset();

      verify(callback.call).called(1);
      verify(() => storage.remove(key.value)).called(1);
      expect(option.value, option.defaultValue, reason: 'Should reset the value.');
    });

    test('Deserialize', () {
      expect(option.value, true);

      // ignore: cascade_invocations
      option.load(false);

      expect(option.value, false);
    });
  });
}
