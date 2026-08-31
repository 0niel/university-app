import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/widgets/ninja_checkbox.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NinjaInput extends StatefulWidget {
  const NinjaInput({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.placeholder,
    this.leadingIcon,
    this.trailing,
    this.errorText,
    this.helperText,
    this.success = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.clearable = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.textStyle,
  }) : showCounter = false;
  const NinjaInput.multiline({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.textStyle,
  })  : leadingIcon = null,
        textAlign = TextAlign.start,
        trailing = null,
        success = false,
        obscureText = false,
        clearable = false,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        textCapitalization = TextCapitalization.sentences,
        autofillHints = null,
        onSubmitted = null,
        showCounter = true;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? placeholder;
  final Widget? leadingIcon;
  final Widget? trailing;
  final String? errorText;
  final String? helperText;
  final bool success;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool clearable;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  final int? maxLines;
  final int? minLines;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool showCounter;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  @override
  State<NinjaInput> createState() => _NinjaInputState();
}

class _NinjaInputState extends State<NinjaInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late bool _obscured = widget.obscureText;
  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = _focusNode.hasFocus;
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() => _hasFocus = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final hasError = widget.errorText != null;
    final multiline = widget.maxLines != 1;
    final focused = _hasFocus && widget.enabled;
    final label = widget.label;
    final helper = widget.errorText ?? widget.helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: NinjaText.body.copyWith(
              fontSize: 12,
              color: colors.mutedDark,
            ),
          ),
          const SizedBox(height: 6),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: _fieldColor(colors, focused: focused),
            borderRadius: BorderRadius.circular(
              multiline ? NinjaRadius.control : NinjaRadius.button,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: multiline ? 84 : 44),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.leadingIcon == null ? 16 : 14,
                vertical: multiline ? 13 : 0,
              ),
              child: _buildBody(colors, multiline: multiline),
            ),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 5),
          _NinjaInputHelper(
            text: helper,
            color: hasError ? colors.scarlet : colors.muted,
            showIcon: hasError,
          ),
        ],
      ],
    );
  }

  Widget _buildBody(NinjaColors colors, {required bool multiline}) {
    final leadingIcon = widget.leadingIcon;
    final field = _buildField(colors, multiline: multiline);

    final row = Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          IconTheme.merge(
            data: IconThemeData(color: colors.muted, size: 17),
            child: leadingIcon,
          ),
          const SizedBox(width: 9),
        ],
        Expanded(child: field),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            final trailing = _buildTrailing(
              context,
              colors,
              text: value.text,
            );
            if (trailing == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: trailing,
            );
          },
        ),
      ],
    );

    final maxLength = widget.maxLength;
    if (!widget.showCounter || maxLength == null) return row;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        row,
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => Text(
            '${value.text.characters.length} / $maxLength',
            textAlign: TextAlign.right,
            style: NinjaText.helper.copyWith(
              fontSize: 11,
              color: colors.muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(NinjaColors colors, {required bool multiline}) {
    final valueColor = widget.enabled ? colors.ink : colors.disabled;
    var style = NinjaText.body.copyWith(color: valueColor);
    if (multiline) {
      style = NinjaText.subtext.copyWith(
        fontSize: 13.5,
        height: 1.5,
        color: valueColor,
      );
    } else if (_obscured) {
      style = style.copyWith(fontSize: 15, letterSpacing: 2);
    }
    final override = widget.textStyle;
    if (override != null) style = style.merge(override);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      maxLength: widget.maxLength,
      maxLines: multiline ? widget.maxLines : 1,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      textAlign: widget.textAlign,
      cursorColor: colors.brand,
      style: style,
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        filled: false,
        counterText: '',
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: NinjaText.body.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.disabled,
        ),
      ),
    );
  }

  Widget? _buildTrailing(
    BuildContext context,
    NinjaColors colors, {
    required String text,
  }) {
    final trailing = widget.trailing;
    if (trailing != null) return trailing;

    if (widget.obscureText) {
      final russian = Localizations.localeOf(context).languageCode == 'ru';
      final label = _obscured
          ? russian
              ? 'Показать пароль'
              : 'Show password'
          : russian
              ? 'Скрыть пароль'
              : 'Hide password';
      return AppPressable(
        pressedScale: 0.9,
        onTap: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        semanticsLabel: label,
        semanticsToggled: !_obscured,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: AppLineIconWidget(
              _obscured ? AppLineIcon.hide : AppLineIcon.view,
              size: 17,
              color: colors.muted,
            ),
          ),
        ),
      );
    }

    if (widget.success) {
      return NinjaCheckMark(size: 15, color: colors.green, strokeWidth: 2.5);
    }

    final canClear = widget.clearable && widget.enabled && text.isNotEmpty;
    if (!canClear) return null;

    final russian = Localizations.localeOf(context).languageCode == 'ru';
    return AppPressable(
      pressedScale: 0.9,
      onTap: () {
        _controller.clear();
        widget.onChanged?.call('');
      },
      semanticsLabel: russian ? 'Очистить поле' : 'Clear field',
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: AppLineIconWidget(
            AppLineIcon.close,
            size: 16,
            color: colors.muted,
          ),
        ),
      ),
    );
  }

  Color _fieldColor(NinjaColors colors, {required bool focused}) {
    if (!widget.enabled) return colors.surface;
    if (widget.errorText != null) return colors.dangerTint;
    if (widget.success) return colors.successTint;
    if (focused) return colors.infoTint;
    return colors.surfaceAlt;
  }
}

class _NinjaInputHelper extends StatelessWidget {
  const _NinjaInputHelper({
    required this.text,
    required this.color,
    required this.showIcon,
  });

  final String text;
  final Color color;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcon) ...[
          AppLineIconWidget(AppLineIcon.alert, size: 13, color: color),
          const SizedBox(width: 5),
        ],
        Expanded(
          child: Text(text, style: NinjaText.helper.copyWith(color: color)),
        ),
      ],
    );
  }
}
