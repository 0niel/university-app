import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ToastController delegates dismissal to its callback', () {
    var dismissed = false;
    final controller = ToastController(() => dismissed = true);

    // The controller has a single command, so a cascade would add noise here.
    // ignore: cascade_invocations
    controller.dismiss();

    expect(dismissed, isTrue);
  });
}
