import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeRpcBuilder extends Fake implements PostgrestFilterBuilder<Object?> {
  FakeRpcBuilder(this._value);

  final Object? _value;

  Future<Object?> _response() => Future.value(_value);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(Object? value) onValue, {
    // ignore: prefer-explicit-function-type
    Function? onError,
  }) {
    return _response().then(onValue, onError: onError);
  }
}
