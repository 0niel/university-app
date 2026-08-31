import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.leadingIcon,
    this.trailing,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.errorText,
    this.helperText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.fillColor,
    this.height = 54,
    this.borderRadius = AppRadius.button,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
  });

  /// Convenience constructor for a multi-line textarea.
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
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.borderRadius = AppRadius.button,
  })  : leadingIcon = null,
        trailing = null,
        obscureText = false,
        showPasswordToggle = false,
        onSubmitted = null,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        autofillHints = null,
        height = 0;

  /// Controls the edited text.
  final TextEditingController? controller;

  /// Placeholder shown when the field is empty.
  final String? placeholder;

  /// Optional uppercase label rendered above the field.
  final String? label;

  /// Which design line icon to show before the text.
  final AppLineIcon? leadingIcon;

  /// Optional custom trailing widget. Ignored when [showPasswordToggle] is set.
  final Widget? trailing;

  /// Whether to obscure the text (password entry).
  final bool obscureText;

  /// Whether to render the eye/eye-off toggle (only when [obscureText]).
  final bool showPasswordToggle;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is tapped (e.g. read-only picker fields).
  final VoidCallback? onTap;

  /// Error message rendered beneath the field; also outlines the fill.
  final String? errorText;

  /// Helper message rendered beneath the field when there is no error.
  final String? helperText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Autofill hints for the platform.
  final Iterable<String>? autofillHints;

  /// Overrides the surface fill colour.
  final Color? fillColor;

  /// Field height (single-line only). Multi-line fields grow with content.
  final double height;

  /// Corner radius of the fill.
  final double borderRadius;

  /// Maximum number of lines. `1` keeps the fixed-height pill; values `> 1`
  /// (or `null`) turn it into a growing textarea.
  final int? maxLines;

  /// Minimum number of lines for multi-line fields.
  final int? minLines;

  /// Optional character limit (shows the platform counter).
  final int? maxLength;

  /// Whether the field accepts input. Disabled fields are dimmed.
  final bool enabled;

  /// Whether the field is read-only (still focusable, e.g. picker triggers).
  final bool readOnly;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// External focus node.
  final FocusNode? focusNode;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional form validator. When provided, the field participates in the
  /// enclosing [Form] and renders the validation error beneath itself.
  final FormFieldValidator<String>? validator;

  /// When to auto-validate; defaults to [AutovalidateMode.onUserInteraction]
  /// when a [validator] is set.
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late bool _obscured = widget.obscureText;
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.validator == null) {
      return _buildField(context, widget.errorText, null);
    }
    return FormField<String>(
      initialValue: widget.controller?.text ?? '',
      validator: widget.validator,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      builder: (state) =>
          _buildField(context, state.errorText, state.didChange),
    );
  }

  Widget _buildField(
    BuildContext context,
    String? errorText,
    ValueChanged<String>? onChangedExtra,
  ) {
    final colors = Theme.of(context).colors;
    final hasError = errorText != null;
    final multiline = widget.maxLines != 1;
    final enabled = widget.enabled;
    final leadingIcon = widget.leadingIcon;
    final label = widget.label;
    final helperText = widget.helperText;

    final fill =
        !enabled ? colors.surfaceLow : (widget.fillColor ?? colors.surfaceHigh);

    Widget? trailing;
    if (widget.showPasswordToggle && widget.obscureText) {
      final russian = Localizations.localeOf(context).languageCode == 'ru';
      final semanticLabel = _obscured
          ? russian
              ? 'Показать пароль'
              : 'Show password'
          : russian
              ? 'Скрыть пароль'
              : 'Hide password';
      trailing = Semantics(
        button: true,
        toggled: !_obscured,
        label: semanticLabel,
        child: ExcludeSemantics(
          child: AppPressable(
            pressedScale: 0.92,
            onTap: () => setState(() => _obscured = !_obscured),
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: AppLineIconWidget(
                  _obscured ? AppLineIcon.hide : AppLineIcon.view,
                  size: 18,
                  color: colors.deactiveDarker,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      trailing = widget.trailing;
    }

    // Flat design: no focus ring. Only a subtle error outline remains so
    // validation failures stay legible; focus is conveyed by the accent caret.
    final border = hasError
        ? Border.all(color: colors.error.withValues(alpha: 0.8))
        : null;

    final field = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: (value) {
        widget.onChanged?.call(value);
        onChangedExtra?.call(value);
      },
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      enabled: enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      cursorColor: colors.primary,
      style: AppText.bodyLarge.copyWith(
        color: enabled ? colors.active : colors.deactiveDarker,
      ),
      // Reset any global InputDecorationTheme so the field is just text inside
      // the surrounding flat pill.
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        filled: false,
        fillColor: Colors.transparent,
        counterText: '',
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: AppText.bodyLarge.copyWith(color: colors.deactiveDarker),
      ),
    );

    final pill = Container(
      height: multiline ? null : widget.height,
      constraints: multiline ? const BoxConstraints(minHeight: 96) : null,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: multiline ? AppSpacing.md : 0,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: border,
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            AppLineIconWidget(
              leadingIcon,
              size: 20,
              color: colors.deactiveDarker,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(child: field),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing,
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xxs, bottom: 10),
            child: Text(
              label.toUpperCase(),
              style: AppText.overline.copyWith(
                color: colors.deactiveDarker,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        Opacity(opacity: enabled ? 1 : 0.7, child: pill),
        if (hasError || widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              left: AppSpacing.xs,
            ),
            child: Text(
              errorText ?? helperText ?? '',
              style: AppText.caption.copyWith(
                color: hasError ? colors.error : colors.deactiveDarker,
              ),
            ),
          ),
      ],
    );
  }
}
