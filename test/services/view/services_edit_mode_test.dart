import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/view/services_view.dart';

void main() {
  test('reordering is available only in configure mode without search', () {
    expect(servicesCanDrag(query: '', editMode: true), isTrue);
    expect(servicesCanDrag(query: '', editMode: false), isFalse);
    expect(servicesCanDrag(query: 'map', editMode: true), isFalse);
  });
}
