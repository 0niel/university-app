import 'package:app_ui/src/widgets/forms/six_digit_code_input.dart';
import 'package:flutter/material.dart';

class NinjaCodeInput extends StatelessWidget {
  const NinjaCodeInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.showKeypad = false,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final bool showKeypad;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return AppCodeInput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      showKeypad: showKeypad,
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
