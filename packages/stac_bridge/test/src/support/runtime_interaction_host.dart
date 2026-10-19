import 'dart:async';
import '../device_actions_test.dart' show DeviceActionsTest;

class RuntimeInteractionHost extends DeviceActionsTest {
  final photo = Completer<String?>();
  final requests = <Object?>[];

  @override
  Future<String?> pickImage({required bool fromCamera}) => photo.future;

  @override
  Future<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, Object?>? query,
    Object? body,
  }) async {
    requests.add(body);
    return {'ok': true};
  }
}
