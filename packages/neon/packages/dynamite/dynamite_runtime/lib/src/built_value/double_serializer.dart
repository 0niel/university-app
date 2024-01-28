import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

/// A built_value serializer for `double` values that does not accept integers.
class DynamiteDoubleSerializer implements PrimitiveSerializer<double> {
  // Constant names match those in [double].
  static const String _nan = 'NaN';
  static const String _infinity = 'INF';
  static const String _negativeInfinity = '-INF';

  @override
  final Iterable<Type> types = BuiltList<Type>([double]);

  @override
  final String wireName = 'double';

  @override
  Object serialize(
    Serializers serializers,
    double aDouble, {
    FullType specifiedType = FullType.unspecified,
  }) {
    if (aDouble.isNaN) {
      return _nan;
    } else if (aDouble.isInfinite) {
      return aDouble.isNegative ? _negativeInfinity : _infinity;
    } else {
      return aDouble;
    }
  }

  @override
  double deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    if (serialized == _nan) {
      return double.nan;
    } else if (serialized == _negativeInfinity) {
      return double.negativeInfinity;
    } else if (serialized == _infinity) {
      return double.infinity;
    } else {
      return serialized as double;
    }
  }
}
