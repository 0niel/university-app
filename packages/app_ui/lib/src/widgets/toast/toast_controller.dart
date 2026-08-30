import 'package:flutter/widgets.dart';

class ToastController {
  const ToastController(this._onDismiss);

  final VoidCallback _onDismiss;

  void dismiss() => _onDismiss();
}
