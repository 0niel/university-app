import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/data/service_layout_repository.dart';

void main() {
  const order = ['a', 'b'];
  final def = {
    'a': ['x', 'y'],
    'b': ['z'],
  };

  group('ServiceLayoutRepository.merge', () {
    test('returns the default layout when nothing is saved', () {
      expect(ServiceLayoutRepository.merge(def, null, order), {
        'a': ['x', 'y'],
        'b': ['z'],
      });
    });

    test('respects the saved arrangement and order (x moved to b)', () {
      final saved = {
        'a': ['y'],
        'b': ['z', 'x'],
      };
      expect(ServiceLayoutRepository.merge(def, saved, order), {
        'a': ['y'],
        'b': ['z', 'x'],
      });
    });

    test('drops ids that no longer exist in config', () {
      final saved = {
        'a': ['x', 'gone'],
        'b': ['z', 'y'],
      };
      expect(ServiceLayoutRepository.merge(def, saved, order), {
        'a': ['x'],
        'b': ['z', 'y'],
      });
    });

    test('appends brand-new config ids to their default group', () {
      final saved = {
        'a': ['x'],
        'b': ['z'],
      };
      expect(ServiceLayoutRepository.merge(def, saved, order), {
        'a': ['x', 'y'],
        'b': ['z'],
      });
    });

    test('places each id once even if saved lists it in two groups', () {
      final saved = {
        'a': ['x', 'z'],
        'b': ['z', 'y'],
      };
      final result = ServiceLayoutRepository.merge(def, saved, order);
      final all = [...?result['a'], ...?result['b']];
      expect(all.where((id) => id == 'z').length, 1);
      expect(all.toSet(), {'x', 'y', 'z'});
    });
  });
}
