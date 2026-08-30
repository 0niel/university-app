import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NinjaCodeInput extends StatefulWidget {
  const NinjaCodeInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onCompleted,
  });
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<NinjaCodeInput> createState() => _NinjaCodeInputState();
}

class _NinjaCodeInputState extends State<NinjaCodeInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late String _code;
  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _code = _controller.text;
    _hasFocus = _focusNode.hasFocus;
    _controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
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
    final code = _controller.text;
    if (code == _code) return;
    setState(() => _code = code);
  }

  void _onFocusChanged() => setState(() => _hasFocus = _focusNode.hasFocus);

  void _onChanged(String value) {
    _controller.selection = TextSelection.collapsed(offset: value.length);
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final code = _code;
    final activeIndex = code.length.clamp(0, widget.length - 1);

    return Stack(
      children: [
        Row(
          children: [
            for (var index = 0; index < widget.length; index++) ...[
              if (index > 0) const SizedBox(width: 8),
              Flexible(
                child: _NinjaCodeBox(
                  colors: colors,
                  digit: index < code.length ? code[index] : null,
                  active: widget.enabled && _hasFocus && index == activeIndex,
                ),
              ),
            ],
          ],
        ),
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
              onChanged: _onChanged,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NinjaCodeBox extends StatelessWidget {
  const _NinjaCodeBox({
    required this.colors,
    required this.active,
    this.digit,
  });

  final NinjaColors colors;
  final String? digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final digit = this.digit;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NinjaRadius.button),
        border: Border.all(
          color: active ? colors.ink : colors.line,
        ),
      ),
      child: SizedBox(
        width: 48,
        height: 56,
        child: Center(
          child: digit == null
              ? _NinjaCodeCaret(visible: active, color: colors.brand)
              : Text(
                  digit,
                  style: NinjaText.tabular(NinjaText.title).copyWith(
                    letterSpacing: 0,
                    color: colors.ink,
                  ),
                ),
        ),
      ),
    );
  }
}

class _NinjaCodeCaret extends StatelessWidget {
  const _NinjaCodeCaret({required this.visible, required this.color});

  final bool visible;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return SizedBox(
      width: 2,
      height: 20,
      child: ColoredBox(color: color),
    );
  }
}
