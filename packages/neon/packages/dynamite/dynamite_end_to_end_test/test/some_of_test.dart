import 'package:dynamite_end_to_end_test/some_of.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('OneOfIntDoubleOther', () {
    OneOfIntDoubleOther object = ($num: 790, string: null);
    Object? json = 790;

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = ($num: 0.05853716010681986, string: null);
    json = 0.05853716010681986;

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = ($num: null, string: r'$String-$value-$');

    json = r'$String-$value-$';

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));
  });

  test('AnyOfIntDoubleOther', () {
    AnyOfIntDoubleOther object = ($num: 499, string: null);
    Object? json = 499;

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = ($num: 0.09712676508277895, string: null);
    json = 0.09712676508277895;

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = ($num: null, string: r'$String-$value-$');

    json = r'$String-$value-$';

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json), equals(object));
  });
}
