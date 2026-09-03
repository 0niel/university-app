import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/forms/six_digit_code_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppCodeInput extends StatefulWidget {
  const AppCodeInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onCompleted,
    this.showKeypad = false,
    this.fillColor,
    this.spacing = AppSpacing.sm,
  });

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool showKeypad;
  final Color? fillColor;
  final double spacing;

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput> {
  late TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late String _code = _controller.text;
  late bool _hasFocus = _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AppCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final value = _controller.value;
      _controller.removeListener(_onControllerChanged);
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController.fromValue(value);
      _code = _controller.text;
      _controller.addListener(_onControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _hasFocus = _focusNode.hasFocus;
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (_controller.text == _code) return;
    if (!mounted) return;
    setState(() => _code = _controller.text);
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _emit(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  void _onFieldChanged(String value) {
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _emit(value);
  }

  void _append(String digit) {
    if (!widget.enabled) return;
    final next = _code + digit;
    if (next.length > widget.length) return;
    _controller.text = next;
    _emit(next);
  }

  void _backspace() {
    if (!widget.enabled || _code.isEmpty) return;
    final next = _code.substring(0, _code.length - 1);
    _controller.text = next;
    _emit(next);
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _code.length.clamp(0, widget.length - 1);
    final showCaret = widget.enabled && (widget.showKeypad || _hasFocus);

    final cells = Row(
      children: [
        for (var index = 0; index < widget.length; index++) ...[
          if (index > 0) SizedBox(width: widget.spacing),
          Expanded(
            child: SixDigitCodeCell(
              digit: index < _code.length ? _code[index] : null,
              active: showCaret && index == activeIndex,
              fillColor: widget.fillColor,
              onTap: widget.showKeypad || !widget.enabled
                  ? null
                  : _focusNode.requestFocus,
            ),
          ),
        ],
      ],
    );

    final row = widget.showKeypad
        ? cells
        : Stack(
            children: [
              cells,
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.number,
                    maxLength: widget.length,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _onFieldChanged,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          );

    if (!widget.showKeypad) return row;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row,
        const SizedBox(height: AppSpacing.sm),
        AppCodeKeypad(
          onKey: _append,
          onBackspace: _backspace,
          enabled: widget.enabled,
        ),
      ],
    );
  }
}

class SixDigitCodeInput extends StatelessWidget {
  const SixDigitCodeInput({
    required this.onCompleted,
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.fillColor,
    this.autofocus = true,
    this.enabled = true,
    this.showKeypad = false,
  });

  final ValueChanged<String> onCompleted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final bool autofocus;
  final bool enabled;
  final bool showKeypad;

  @override
  Widget build(BuildContext context) {
    return AppCodeInput(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onCompleted: onCompleted,
      fillColor: fillColor,
      autofocus: autofocus,
      enabled: enabled,
      showKeypad: showKeypad,
    );
  }
}
