import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/widgets/forms/six_digit_code_cell.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SixDigitCodeInput extends StatefulWidget {
  const SixDigitCodeInput({
    required this.onCompleted,
    super.key,
    this.fillColor,
    this.autofocus = true,
  });

  final ValueChanged<String> onCompleted;

  final Color? fillColor;

  final bool autofocus;

  @override
  State<SixDigitCodeInput> createState() => _SixDigitCodeInputState();
}

class _SixDigitCodeInputState extends State<SixDigitCodeInput> {
  static const _length = 6;

  final List<_CodeField> _fields = [];

  @override
  void initState() {
    super.initState();
    _fields.addAll(
      List.generate(
        _length,
        // Each field owns disposable resources released from State.dispose().
        (index) => _CodeField(index: index, onKey: _onKey),
      ),
    );
  }

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < _length - 1) {
      _fields.elementAtOrNull(index + 1)?.focusNode.requestFocus();
    }

    final code = _fields.map((field) => field.controller.text).join();
    if (code.length == _length) {
      widget.onCompleted(code);
    }
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    final field = _fields.elementAtOrNull(index);
    final isBackspace = event.logicalKey == LogicalKeyboardKey.backspace;
    if (event is KeyDownEvent &&
        isBackspace &&
        field?.controller.text.isEmpty == true &&
        index > 0) {
      final previousField = _fields.elementAtOrNull(index - 1);
      previousField?.controller.clear();
      previousField?.focusNode.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_length, (index) {
        final field = _fields.elementAtOrNull(index);
        if (field == null) {
          return const SizedBox.shrink();
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _length - 1 ? 0 : AppSpacing.sm,
            ),
            child: SixDigitCodeCell(
              controller: field.controller,
              focusNode: field.focusNode,
              fillColor: widget.fillColor,
              autofocus: widget.autofocus && index == 0,
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        );
      }),
    );
  }
}

class _CodeField {
  _CodeField({
    required this.index,
    required KeyEventResult Function(int, KeyEvent) onKey,
  })  : controller = TextEditingController(),
        focusNode = FocusNode(onKeyEvent: (_, event) => onKey(index, event));

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
