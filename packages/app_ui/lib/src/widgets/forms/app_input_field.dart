import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:app_ui/src/widgets/forms/app_field_label.dart';
import 'package:app_ui/src/widgets/forms/app_form_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.errorText,
    this.helperText,
    this.success = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.fillColor,
    this.height = AppControlSize.field,
    this.borderRadius = AppRadius.field,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.showClear = true,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.validator,
    this.autovalidateMode,
    this.validateOnBlur = false,
  });

  const AppInputField.multiline({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.onChanged,
    this.onTap,
    this.errorText,
    this.helperText,
    this.fillColor,
    this.maxLines = 6,
    this.minLines = 3,
    this.maxLength,
    this.showCounter = true,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.validateOnBlur = false,
    this.textStyle,
    this.borderRadius = AppRadius.field,
  })  : leadingIcon = null,
        leading = null,
        trailing = null,
        obscureText = false,
        showPasswordToggle = false,
        success = false,
        showClear = false,
        onSubmitted = null,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        textCapitalization = TextCapitalization.sentences,
        autofillHints = null,
        textAlign = TextAlign.start,
        height = AppControlSize.field;

  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final AppLineIcon? leadingIcon;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final bool showPasswordToggle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? errorText;
  final String? helperText;
  final bool success;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final Color? fillColor;
  final double height;
  final double borderRadius;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool showCounter;
  final bool showClear;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  final bool validateOnBlur;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late bool _obscured = widget.obscureText;
  late bool _focused = _focusNode.hasFocus;
  var _blurred = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final value = _controller.value;
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController.fromValue(value);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focused = _focusNode.hasFocus;
      _focusNode.addListener(_onFocusChanged);
    }
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!mounted) return;
    final focused = _focusNode.hasFocus;
    setState(() {
      if (_focused && !focused) _blurred = true;
      _focused = focused;
    });
  }

  String? _visibleError(String? errorText) =>
      widget.validateOnBlur && !_blurred ? null : errorText;

  @override
  Widget build(BuildContext context) {
    if (widget.validator == null) {
      return _build(context, _visibleError(widget.errorText), null);
    }
    return FormField<String>(
      key: ObjectKey(_controller),
      initialValue: _controller.text,
      validator: widget.validator,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      builder: (state) =>
          _build(context, _visibleError(state.errorText), state.didChange),
    );
  }

  Color _fill(AppColors colors, String? errorText) {
    if (!widget.enabled) return colors.canvas;
    if (widget.fillColor != null) return widget.fillColor!;
    if (errorText != null) return colors.examTint;
    if (widget.success) return colors.lectureTint;
    if (_focused) return colors.tint;
    return colors.surface2;
  }

  Widget _build(
    BuildContext context,
    String? errorText,
    ValueChanged<String>? onValidate,
  ) {
    final colors = context.colors;
    final multiline = widget.maxLines != 1;
    final label = widget.label;
    final helper = widget.helperText;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final leading = widget.leading ??
        (widget.leadingIcon == null
            ? null
            : AppLineIconWidget(
                widget.leadingIcon!,
                size: AppFormMetrics.leadingIcon,
                color: colors.muted,
              ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) AppFieldLabel(label),
        AnimatedContainer(
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: multiline ? null : widget.height,
          constraints: multiline
              ? const BoxConstraints(minHeight: AppFormMetrics.multilineHeight)
              : null,
          padding: EdgeInsets.only(
            left: leading == null
                ? AppFormMetrics.inset
                : AppFormMetrics.leadingInset,
            right: widget.showPasswordToggle && widget.obscureText
                ? AppFormMetrics.trailingInset
                : leading == null
                    ? AppFormMetrics.inset
                    : AppFormMetrics.leadingInset,
            top: multiline ? AppFormMetrics.multilineInset : AppSpacing.zero,
            bottom: multiline ? AppFormMetrics.multilineInset : AppSpacing.zero,
          ),
          decoration: BoxDecoration(
            color: _fill(colors, errorText),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: multiline
              ? _buildMultiline(colors, onValidate)
              : _buildSingleLine(colors, leading, onValidate),
        ),
        if (errorText != null)
          _AppFieldMessage(
            text: errorText,
            color: colors.danger,
            showIcon: true,
          )
        else if (helper != null)
          _AppFieldMessage(text: helper, color: colors.muted, showIcon: false),
      ],
    );
  }

  Widget _buildSingleLine(
    AppColors colors,
    Widget? leading,
    ValueChanged<String>? onValidate,
  ) {
    return Row(
      children: [
        if (leading != null) ...[
          leading,
          const SizedBox(width: AppFormMetrics.leadingGap),
        ],
        Expanded(child: _buildField(colors, onValidate, multiline: false)),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            final trailing =
                _buildTrailing(context, colors, value.text, onValidate);
            return trailing ?? const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMultiline(AppColors colors, ValueChanged<String>? onValidate) {
    final maxLength = widget.maxLength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildField(colors, onValidate, multiline: true),
        if (widget.showCounter && maxLength != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => Text(
              '${value.text.characters.length} / $maxLength',
              textAlign: TextAlign.right,
              style:
                  AppText.sans(AppFormMetrics.counterFontSize, FontWeight.w500)
                      .copyWith(
                color: colors.muted,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildField(
    AppColors colors,
    ValueChanged<String>? onValidate, {
    required bool multiline,
  }) {
    final ink = widget.enabled ? colors.ink : colors.muted2;
    var style = AppText.body.copyWith(color: ink);
    if (multiline) {
      style = AppText.sans(
        AppFormMetrics.multilineFontSize,
        FontWeight.w500,
        height: AppFormMetrics.multilineLineHeight,
      ).copyWith(
        color: ink,
      );
    } else if (_obscured) {
      style = AppText.sans(AppFormMetrics.passwordFontSize, FontWeight.w600)
          .copyWith(
        color: ink,
        letterSpacing: AppFormMetrics.passwordLetterSpacing,
      );
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
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: multiline ? widget.maxLines : 1,
      minLines: multiline ? widget.minLines : null,
      textAlign: widget.textAlign,
      cursorColor: colors.accent,
      style: style,
      onChanged: (value) {
        widget.onChanged?.call(value);
        onValidate?.call(value);
      },
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
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
        hintStyle:
            AppText.sans(AppFormMetrics.hintFontSize, FontWeight.w600).copyWith(
          color: colors.muted2,
        ),
      ),
    );
  }

  Widget? _buildTrailing(
    BuildContext context,
    AppColors colors,
    String text,
    ValueChanged<String>? onValidate,
  ) {
    if (widget.showPasswordToggle && widget.obscureText) {
      final russian = Localizations.localeOf(context).languageCode == 'ru';
      return AppPressState(
        enabled: widget.enabled,
        onTap: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        pressedScale: 0.9,
        semanticsLabel: _obscured
            ? (russian ? 'Показать пароль' : 'Show password')
            : (russian ? 'Скрыть пароль' : 'Hide password'),
        semanticsToggled: !_obscured,
        builder: (context, {required pressed}) => SizedBox.square(
          dimension: AppControlSize.iconButton,
          child: Center(
            child: AppLineIconWidget(
              _obscured ? AppLineIcon.hide : AppLineIcon.view,
              size: AppFormMetrics.leadingIcon,
              color: colors.muted,
            ),
          ),
        ),
      );
    }

    if (widget.trailing != null) return widget.trailing;

    if (widget.success) {
      return AppLineIconWidget(
        AppLineIcon.check,
        size: AppFormMetrics.successIcon,
        color: colors.lecture,
        strokeWidth: AppFormMetrics.successStroke,
      );
    }

    if (!widget.showClear ||
        !widget.enabled ||
        widget.readOnly ||
        text.isEmpty) {
      return null;
    }

    final russian = Localizations.localeOf(context).languageCode == 'ru';
    return AppPressState(
      onTap: () {
        _controller.clear();
        widget.onChanged?.call('');
        onValidate?.call('');
      },
      pressedScale: 0.9,
      semanticsLabel: russian ? 'Очистить поле' : 'Clear field',
      builder: (context, {required pressed}) => SizedBox.square(
        dimension: AppControlSize.touchTarget,
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox.square(
            dimension: AppFormMetrics.clearVisualSize,
            child: Center(
              child: AppLineIconWidget(
                AppLineIcon.close,
                size: AppIconSize.sm,
                color: colors.muted,
                strokeWidth: AppFormMetrics.iconStroke,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppFieldMessage extends StatelessWidget {
  const _AppFieldMessage({
    required this.text,
    required this.color,
    required this.showIcon,
  });

  final String text;
  final Color color;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppFormMetrics.messageGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            AppLineIconWidget(
              AppLineIcon.alert,
              size: AppFormMetrics.messageIcon,
              color: color,
              strokeWidth: AppFormMetrics.iconStroke,
            ),
            const SizedBox(width: AppFormMetrics.messageGap),
          ],
          Expanded(
            child: Text(
              text,
              style: AppText.sans(
                AppFormMetrics.messageFontSize,
                FontWeight.w500,
                height: AppFormMetrics.messageLineHeight,
              ).copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
