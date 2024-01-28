import 'package:built_value/json_object.dart';
import 'package:dynamite_end_to_end_test/type_defs.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('TypeDefs', () {
    expect(1, isA<TypeResultBase>());
    expect(JsonObject('value'), isA<EmptySchema>());
    expect(Base(), isA<Redirect>());
    expect(1, isA<RedirectBaseType>());
    expect(JsonObject('value'), isA<RedirectEmptyType>());
    expect(($int: null, base: null, jsonObject: null), isA<SomeOfRedirect>());
  });
}
